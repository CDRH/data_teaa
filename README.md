# data_teaa
Data Repository for To Enter Africa from America 

## Posting files on dev subsite

ssh into `cdrhdev1.unl.edu`

```
ssh USERNAME@cdrhdev1.unl.edu
```

pull changes to repo (ask for help if you need to set up ssh key or follow directions [on the github ssh page](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent))

```
cd /var/local/www/data/collections/teaa
```

```
git pull
```

generate new html

```
post -x html
```

post files to index

```
post
```

If you have made a lot of changes, especially any file deletion, you should clear the TEAA files before you post:

```
es_clear_index
```

## Spreadsheets

The personography and Images are populated via CSV's downloaded from Google Sheets: 

### Images

https://docs.google.com/spreadsheets/d/1KN06GKm2XucbCUl49alPFP89GUtJO6hTZ4fQ3urJZlE/edit#gid=0

### Personography

(link to come)
