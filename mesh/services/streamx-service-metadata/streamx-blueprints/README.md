Files in this directory must contain blueprints service metadata in the same version as declared in mesh.yaml
in the `defaultImageTag` property for `defaultRegistry: ghcr.io/streamx-dev/streamx-blueprints`.

How to re-generate the files:
 * https://github.com/streamx-dev/streamx-blueprints/blob/main/RELEASE.md#add-services-metadata-to-github-release
 * Extract files from the generated zip file
 * Copy them to new folder with the version as its name
 * Re-format the JSONs
 * Remove folder for the old version
