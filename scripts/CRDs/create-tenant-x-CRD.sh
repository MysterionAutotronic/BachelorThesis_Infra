#!/usr/bin/env bash
set -euo pipefail

# 🧾 Configurable values
ROOT_WS=":root"
TENANT_ID="$1"
TENANT_WS=":root:tenants:tenant-${TENANT_ID}"
CRD_FILE="k8s/CRDs/tenant-${TENANT_ID}-crd.yaml"
EXPORT_FILE="k8s/CRDs/tenant-${TENANT_ID}-export.yaml"

# Check if TENANT_ID is provided
if [ -z "$TENANT_ID" ]; then
    echo "❌ Tenant ID is required as the first argument. Usage: $0 <TENANT_ID>"
    exit 1
fi

# CRD
cat > $CRD_FILE <<EOF
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
    name: tenantconfigs-${TENANT_ID}.example.com
spec:
    group: example.com
    scope: Namespaced
    names:
        plural: tenantconfigs
        singular: tenantconfig
        kind: TenantConfig
    versions:
        - name: v1alpha1
            served: true
            storage: true
            schema:
                openAPIV3Schema:
                    type: object
                    properties:
                        spec:
                            type: object
                            required:
                                - address
                                - companyName
                                - proposition
                                - products
                                - about
                            properties:
                                address:
                                    type: object
                                    required:
                                        - country
                                        - zipCode
                                        - city
                                        - street
                                        - streetNumber
                                    properties:
                                        country:
                                            type: string
                                            pattern: '^[a-z]{2}-[A-Z]{2}$'
                                        zipCode:
                                            type: string
                                            pattern: '^[0-9]{4,10}$'
                                        city:
                                            type: string
                                            minLength: 1
                                        street:
                                            type: string
                                            minLength: 1
                                        streetNumber:
                                            type: string
                                            pattern: '^[0-9]+[a-zA-Z]?$'
                                companyName:
                                    type: string
                                    minLength: 1
                                proposition:
                                    type: string
                                    minLength: 1
                                products:
                                    type: array
                                    minItems: 1
                                    items:
                                        type: string
                                about:
                                    type: string
                                    minLength: 1
EOF

# Export
cat > "$EXPORT_FILE" <<EOF
apiVersion: apis.kcp.io/v1alpha1
kind: APIExport
metadata:
    name: tenantconfigs-${TENANT_ID}.example.com
spec:
    latestResourceSchemas:
        - example.com_tenantconfigs
EOF