#!/bin/sh

# Download XML
wget -q http://autoload.avito.ru/format/Autocatalog.xml -O - |

# grep REGEX
# ^([\s\t]+)? - Any tabulate or spaces in the begining 
# <(catalog|(make|model)[^>]*name) - Catalog tag, Make or Model tags with name parameter present
# <(\/(catalog|make)) - Catalog or Make close tags
grep -P -i '^([\s\t]+)?((<(catalog|(make|model)[^>]*name))|(<\/(make|catalog)))' | 

# Replace Catalog tags
perl -pe 's/<cat[^>]*>/{/gi;s/<\/cat[^>]*>/}/gi' | 

# Replace Make tag
perl -pe 's/<make\s?id="(\d*)"[^(name)]*name="([^"]*).*$/"\1":{"id":\1,"name":"\2","models":{/gi;s/<\/make.*$/}},/gi' |

# Remplace Model tag
perl -pe 's/<model\s?id="(\d*)"[^(name)]*name="([^"]*).*$/"\1":{"id":\1,"name":"\2"},/gi' |

# Remove line breakes, spaces
perl -pe 's/[\t\r\n]*//g' | 

# Remove extra commas
perl -pe 's/,(}|])/\1/g' |

# Save to file
cat > marks.json

