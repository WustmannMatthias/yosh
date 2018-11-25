# setopt functions we need
shopt -s extglob
shopt -s nullglob
shopt -s expand_aliases

# Auto Load all

for file in /usr/share/yosh/{lib,func,auth,session,config}/*.sh
do
    source $file
done

for file in /usr/share/yosh/package/*/{lib,func,auth,session,config}/*.sh
do
    source $file
done

# Source custom lib's
for file in ${DOCUMENT_ROOT%/}/../{lib,func,auth,session,config}/*.sh
do
    source $file
done


# Packaging system
# Lib Files for packaging system
for file in ${DOCUMENT_ROOT%/}/../package/*/{lib,func,auth,session,config}/*.sh
do
    source $file
done

for file in ${etc_conf_dir%/}/*.sh
do
    source $file
done