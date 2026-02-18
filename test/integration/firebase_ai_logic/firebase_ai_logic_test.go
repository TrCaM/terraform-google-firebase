/**
 * Copyright 2026 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package firebase_ai_logic

import (
	"fmt"
	"os/exec"
	"strings"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/stretchr/testify/assert"
	"github.com/terraform-google-modules/terraform-google-firebase/test/integration/firebase_util"
)

func TestFirebaseAiLogic(t *testing.T) {
	firebaseTest := tft.NewTFBlueprintTest(t)

	firebaseTest.DefineVerify(func(assert *assert.Assertions) {
		firebaseTest.DefaultVerify(assert)

		projectID := firebaseTest.GetStringOutput("project_id")
		location := "global"

		// 1. Verify Enabled APIs
		services := gcloud.Run(t, "services list", gcloud.WithCommonArgs([]string{
			"--project", projectID,
			"--filter", "config.name:(firebase.googleapis.com OR firebasevertexai.googleapis.com OR generativelanguage.googleapis.com OR aiplatform.googleapis.com)",
			"--format", "json",
		})).Array()
		expectedAPIs := []string{
			"firebase.googleapis.com",
			"firebasevertexai.googleapis.com",
			"generativelanguage.googleapis.com",
			"aiplatform.googleapis.com",
		}
		for _, api := range expectedAPIs {
			match := utils.GetFirstMatchResult(t, services, "config.name", api)
			assert.Equal("ENABLED", match.Get("state").String(), fmt.Sprintf("%s should be enabled", api))
		}

		// 2. Obtain Access Token
		out, err := exec.Command("gcloud", "auth", "print-access-token").Output()
		assert.NoError(err, "Failed to get access token")
		token := strings.TrimSpace(string(out))

		// 3. Verify AI Logic Config
		config := firebase_util.GetAiLogicConfig(t, projectID, location, token)
		assert.Equal("NONE", config.Get("telemetryConfig.mode").String(), "Telemetry mode should be NONE")
		assert.Equal(float64(1), config.Get("telemetryConfig.samplingRate").Float(), "Telemetry sampling rate should be 1")

		// 4. Verify Prompt Templates
		templates := firebase_util.GetAiLogicTemplates(t, projectID, location, token)
		expectedTemplates := []string{"hello-world-direct", "hello-world-gcs"}
		assert.Len(templates, len(expectedTemplates), "Should have exactly 2 prompt templates")

		for _, templateId := range expectedTemplates {
			fullName := fmt.Sprintf("projects/%s/locations/%s/templates/%s", projectID, location, templateId)
			match := utils.GetFirstMatchResult(t, templates, "name", fullName)
			assert.True(match.Exists(), fmt.Sprintf("Template %s should exist", templateId))
		}

		// 5. Verify the associated Web App exists
		webApps := firebase_util.GetAppList(t, projectID, firebase_util.Web, token)
		assert.NotEmpty(webApps, "Should have at least one web app registered")
	})

	firebaseTest.Test()
}
