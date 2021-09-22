import configparser
import json
config = configparser.ConfigParser()
config.read('config.ini')



def iniFileToJson(fileName):
    config = configparser.ConfigParser()
    config.read(fileName)
    # convert config to json
    jsonData = json.dumps(config._sections, indent=2)
    return jsonData

for Section in config.sections():
    # loop over section items and key, value pairs
    for key, value in config.items(Section):
        print(Section, ">\t", key, value)

myConfig = iniFileToJson('config.ini')

# pretty print json data
print(myConfig)

# json to data
myData = json.loads(myConfig)

for key in myData:
    print(key)