{{/*
Get Nextloud MySQL Database Name
*/}}
{{- define "mysql.DatabaseName" -}}
{{- print "nextcloud" -}}
{{- end -}}


{{- define "mysql.imageName" -}}
{{- print "mysql:8.0.30" -}}
{{- end -}}


{{/*
Retrieve mysql backup name
This will return a unique name based on revision and chart numbers specified.
*/}}
{{- define "mysql.backupName" -}}
{{- $upgradeDict := .Values.ixChartContext.upgradeMetadata -}}
{{- printf "mysql-backup-from-%s-to-%s-revision-%d" $upgradeDict.oldChartVersion $upgradeDict.newChartVersion (int64 $upgradeDict.preUpgradeRevision) -}}
{{- end }}


{{/*
Retrieve mysql credentials for environment variables configuration
*/}}
{{- define "mysql.envVariableConfiguration" -}}
{{ $envList := list }}
{{ $envList = mustAppend $envList (dict "name" "MYSQL_USER" "valueFromSecret" true "secretName" "db-details" "secretKey" "db_user") }}
{{ $envList = mustAppend $envList (dict "name" "MYSQL_PASSWORD" "valueFromSecret" true "secretName" "db-details" "secretKey" "db_password") }}
{{ $envList = mustAppend $envList (dict "name" "MYSQL_ROOT_PASSWORD" "valueFromSecret" true "secretName" "db-details" "secretKey" "db_root_password") }}
{{ include "common.containers.environmentVariables" (dict "environmentVariables" $envList) }}
{{- end -}}


{{/*
Retrieve mysql volume configuration
*/}}
{{- define "mysql.volumeConfiguration" -}}
{{ include "common.storage.configureAppVolumes" (dict "appVolumeMounts" .Values.mysqlAppVolumeMounts "emptyDirVolumes" .Values.emptyDirVolumes "ixVolumes" .Values.ixVolumes) | nindent 0 }}
{{- end -}}


{{/*
Retrieve mysql volume mounts configuration
*/}}
{{- define "mysql.volumeMountsConfiguration" -}}
{{ include "common.storage.configureAppVolumeMountsInContainer" (dict "appVolumeMounts" .Values.mysqlAppVolumeMounts ) | nindent 0 }}
{{- end -}}

