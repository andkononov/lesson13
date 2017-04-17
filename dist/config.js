// List of PuppetDB servers, pairs of name and URL
// The first one will be used as the default server
PUPPETDB_SERVERS = [["production","/api"]];

// A list of important facts that you want shown in the node detail view
NODE_FACTS = ["operatingsystem","operatingsystemrelease","manufacturer","productname","processorcount","memorytotal","ipaddress"];

// The amount of hours since the last check-in after which a node is considered unresponsive
UNRESPONSIVE_HOURS = 2;

// Customisable dashboard panels
// type can be either 'primary', 'success', 'info', 'warning' or 'danger'
// Different types will be displayed with different colors
DASHBOARD_PANELS = [{"name":"Unresponsive nodes","type":"danger","query":"#node.report_timestamp < @\"now - 2 hours\""},{"name":"Nodes in production env","type":"success","query":"#node.catalog_environment = production"},{"name":"Nodes in non-production env","type":"warning","query":"#node.catalog_environment != production"}];

// Google Analytics settings
GA_TRACKING_ID = 'UA-XXXXXXXX-YY';
GA_DOMAIN = 'auto';

