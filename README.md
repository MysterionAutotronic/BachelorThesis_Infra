# BachelorThesis_Infra

**Run all scripts from Project Root "`/BachelorThesis_Infra`"**

## 1. Install Dependencies

```sh
sudo ./scripts/install-deps.sh
```

## 2. Restart for docker group privileges

```sh
sudo reboot
```

## 3. Clone Repos

```sh
./scripts/clone-repos.sh
```

## 4. Setup kcp

```sh
./scripts/setup-kcp.sh
```

## 5. Start kcp

```sh
./scripts/start-kcp.sh
```

## 6. Update Krew

```sh
./scripts/update-krew.sh
```

## 7. Setup Krew plugins

```sh
./scripts/setup-krew-plugins.sh
```

## 8. Add to PATH

```sh
source ./scripts/path.sh
```

# 9. Setup TMC

```sh
./scripts/setup-tmc.sh
```

# 10. Add to PATH again if necessary

```sh
source ./scripts/path.sh
```

## Helpful commands:

### Workspaces

Show workspace structure as tree:
```sh
kubectl ws tree
```

Show all workspaces and URLs:
```sh
kubectl get workspaces
```

Show current workspace:
```sh
kubectl ws current
```

Use a certain workspace:
```sh
kubectl ws use :root:<NAME>
```

Get clusters and context:
```sh
kubectl config view --minify
```

Check workspace status:
```sh
kubectl get workspaces <NAME_WITHOUT_PARENT> -o jsonpath='{.status.phase}{"\n"}'
```

Show detailed workspace status:
```sh
kubectl get workspaces <NAME_WITHOUT_PARENT> -o yaml | grep -A4 "status:"          
```

### RBAC

Get current user:
```sh
kubectl config view --minify -o jsonpath='{.users[0].name}'
```

### API binding

Check privileges to bind API export:
```sh
kubectl auth can-i bind apiexports.apis.kcp.io/content/:root:<NAME>
```

Get FQN for apibinding:
```sh
kubectl get apiexport <APIBINDING> -o jsonpath='{.metadata.annotations.kcp.io/path}:{.metadata.name}{"\n"}'
```

Get binding status for apibinding:
```sh
kubectl get apibinding <APIBINDING> -o=jsonpath='{.status.phase}{"\n"}'
```

Get all binding conditions for apibinding:
```sh
kubectl get apibinding kubernetes -o=jsonpath='{range .status.conditions[*]}{.type} {.status} {.reason} {.message}{"\n"}{end}'
```

Delete apibinding:
```sh
kubectl delete apibinding <APIBINDING> --ignore-not-found
```

Show role bindings
```sh
kubectl get clusterrolebinding
```

## API Resources

Show all available API resources inside a workspace:
```sh
kubectl api-resources
```

## Debug Pod

```sh
kubectl apply -f ./k8s/deployments/debug.yaml
kubectl get pods debug # wait for ready
kubectl exec -it debug -- bash #enter
```