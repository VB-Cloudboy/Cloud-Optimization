#===================================================================================
# Created by       : Vijay Borkar [VB-Cloudboy --> https://github.com/VB-Cloudboy]
# Version          : 0.1 | Deleting volumes which are in available state
#===================================================================================

import boto3
ec2 = boto3.resource('ec2',region_name='region-name(example: us-east-1)')

def lambda_handler(event, context):
for vol in ec2.volumes.all():
if vol.state=='available':
if vol.tags is None:
vid=vol.id
v=ec2.Volume(vol.id)
v.delete()
print "Deleted " +vid
continue
for tag in vol.tags:
if tag['Key'] == 'Name':
value=tag['Value']
if value != 'DND' and vol.state=='available':
vid=vol.id
v=ec2.Volume(vol.id)
v.delete()
print "Deleted " +vid