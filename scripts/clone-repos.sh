if [ ! -d "BachelorThesis_TenantFE" ]; then
    echo "Cloning Tenant Frontend repository..."
    git clone https://github.com/MysterionAutotronic/BachelorThesis_TenantFE.git
else
    echo "Tenant Frontend repository already exists."
fi

if [ ! -d "BachelorThesis_TenantBE" ]; then
    echo "Cloning Tenant Backend repository..."
    git clone https://github.com/MysterionAutotronic/BachelorThesis_TenantBE.git
else
    echo "Tenant Backend repository already exists."
fi

if [ ! -d "BachelorThesis_DashboardFE" ]; then
    echo "Cloning Dashboard Frontend repository..."
    git clone https://github.com/MysterionAutotronic/BachelorThesis_DashboardFE.git
else
    echo "Dashboard Frontend repository already exists."
fi

if [ ! -d "BachelorThesis_DashboardBE" ]; then
    echo "Cloning Dashboard Backend repository..."
    git clone https://github.com/MysterionAutotronic/BachelorThesis_DashboardBE.git
else
    echo "Dashboard Backend repository already exists."
fi