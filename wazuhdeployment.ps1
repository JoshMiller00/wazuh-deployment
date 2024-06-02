param

(    
[Parameter(Mandatory=$true)]
[string]$manager
[string]$agents
[string]$domain
)




$address = $agents.Split(",")

#put all computer names in an array

$count = $address.Count

#count number of items in array

$array = 1..$count 

#number of times to run through the loop

$loop = 1

#start loop counter

do {

invoke-command -computername $address[$loop - 1] -credential $domain\Administrator -scriptblock

{

Invoke-WebRequest -Uri https://packages.wazuh.com/4.x/windows/wazuh-agent-4.6.0-1.msi -OutFile ${env.temp}\wazuh-agent; msiexec.exe /i ${env.tmp}\wazuh-agent /q WAZUH_MANAGER=$manager WAZUH_AGENT_GROUP='windows' WAZUH_AGENT_NAME="Agent$loop" WAZUH_REGISTRATION_SERVER=$manager

NET START WazuhSvc
}

$loop++

} while ($loop -le $count)

#install wazuh agent on each client 