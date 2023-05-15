# Example Stateful Workload Profile

The Stateful Workload Profile requires a supporting resource definition to work. The resource definition can be found in `defs` directory. The workload profile is in `stateful-workload`.

To use the commands in this README, make sure the environment is set up with the following 2 environment variables:
| Variable          | Description                                       |
| ----------------- | ------------------------------------------------- |
| `HUMANITEC_ORG`   | The org to add or update the workload profile in. |
| `HUMANITEC_TOKEN` | An API or Session token with Admin or the org.    |




## Register the new workload profile with Humanitec

This needs to be done once per workload profile.

```
curl "https://api.humanitec.io/orgs/${HUMANITEC_ORG}/workload-profiles" \
  -X POST \
  -H "Authorization: Bearer $HUMANITEC_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"id": "stateful-workload"}'
```

## Package the workload profile
It is important to update the version in `stateful-workload/Chart.yaml` as Humanitec uses the chart version as the version of the workload profile.

```
PROFILE_VERSION=$(cat stateful-workload/Chart.yaml | grep "version:" | sed 's/version://g' | tr -d '[:space:]')
tar -czf "stateful-workload-${PROFILE_VERSION}.tgz" stateful-workload
```

## Add a new workload profile version

```
curl "https://api.humanitec.io/orgs/${HUMANITEC_ORG}/workload-profiles/stateful-workload/versions" \
  -F "file=@stateful-workload-${PROFILE_VERSION}.tgz" \
  -F "metadata=@stateful-workload/profile.json;type=application/json" \
  -H "Authorization: Bearer $HUMANITEC_TOKEN"
```
## Register the Resource Definition

```
humctl apply -c /orgs/${HUMANITEC_ORG} -f defs/stateful-volume-def.yaml
```

