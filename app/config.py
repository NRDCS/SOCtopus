# Base config
import configparser

#parser = configparser.ConfigParser()
parser = configparser.ConfigParser(interpolation=None)
parser.read('SOCtopus.conf')

filename = parser.get('log', 'logfile')


