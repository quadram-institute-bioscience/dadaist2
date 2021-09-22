
import configparser

VERSION = "2.0.0"

def version():
    return VERSION
 
 
class DadaistConfig(object):
    def __init__(self, configfile, protocol=None):
        self.config = configparser.ConfigParser()
        self.config.read(configfile)
        self.defaultdir = self.config.get('Dadaist', 'defaultdir')
        self.refdir = self.config.get('Dadaist', 'refdir')
        self.defaultdb = self.config.get('refs', 'defaultdb')
        self.protocol = {}
        for section in self.config.sections():
            if section.startswith('protocol.'):
                protocol = section.split('.')[1]
                self.protocol[protocol] = {}
                # print all fields in this section
                for field in self.config.options(section):
                    self.protocol[protocol][field] = self.config.get(section, field)

        if protocol:
            section = 'protocol.' + protocol
            self.primerFor = self.config.get(section, 'primerFor')
            self.primerRev = self.config.get(section, 'primerRev')
   
    def set(self, section, option, value):
        self.config.set(section, option, value)
        with open(self.configfile, 'w') as configfile:
            self.config.write(configfile)
    
    def get(self, section, option):
        return self.config.get(section, option)


if __name__ == "__main__":
    print(version())