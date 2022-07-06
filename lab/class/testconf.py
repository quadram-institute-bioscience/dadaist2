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

# Using the configparser module ==============================================================

for Section in config.sections():
    # loop over section items and key, value pairs
    for key, value in config.items(Section):
        print(Section, ">\t", key, value)

# Using JSON ================================================================
myConfigAsJsonString = iniFileToJson('config.ini')

# pretty print json data
print(type(myConfigAsJsonString), myConfigAsJsonString)

# json to data
myConfigParsedFromJson = json.loads(myConfigAsJsonString)

for key in myConfigParsedFromJson:
    print(key)
    for j in myConfigParsedFromJson[key]:
        print("\t", j, ":", myConfigParsedFromJson[key][j])
        