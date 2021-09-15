#!/usr/bin/python

"""
Info gathering python script - scans and displays open ports, the 
services running on them, the state of the ports, and OS of the system. 
"""

import sys
import os
import nmap

def main():
	if(os.getuid() == 0):
		if(len(sys.argv) <= 1 or len(sys.argv) > 2):
			print("Usage: ./portscan.py <ip addr>")
		else:
			portScan()
	else:
		print("Use sudo when running this script")

def osDetection():
	nm = nmap.PortScanner()
	OSinfo = ""
	nm.scan(sys.argv[1], arguments='-O')
	if 'osmatch' in nm[sys.argv[1]]:
		if len(nm[sys.argv[1]]['osmatch']) == 0:
			OSinfo = "OS info: N/A"
		else:
			for osclass in nm[sys.argv[1]]['osmatch'][0]['osclass']:
				OSinfo = ("OS info : vendor - "+ osclass['vendor']+", family - " +osclass['osfamily']+", type - " +osclass['type'])
	return OSinfo

def portScan():
	OSinfo = osDetection()
	nm = nmap.PortScanner()
	nm.scan(sys.argv[1], '1-1000')     #Scans ports 1-1000
	
	for host in nm.all_hosts():
		print('\n--------------------------------------------------')
		print('Host : %s (%s)' % (host, nm[host].hostname()))
		print('State : %s' % nm[host].state())
		print(OSinfo)
		for proto in nm[host].all_protocols():
			print('--------------------------------------------------')
			print('Protocol : %s\n' % proto)

			lport = nm[host][proto].keys()
			lport.sort()
			for port in lport:
				print('port : %s\tstate : %s\tservice : %s' % (port, nm[host][proto][port]['state'],  nm[host][proto][port]['name']))

main()