#  ectool --server XXXX login admin yyyyy

ectool publishArtifactVersion \
  --version 1.0.3 \
  --artifactName com.electriccloud:EC-dslDeploy \
  --includePatterns "**/*" \
  --fromDirectory repo \
  --repositoryName default