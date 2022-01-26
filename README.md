# Data Repository for To Enter Africa from America: The United States, Africa, and the New Imperialism, 1862-1919

## About This Data Repository

**How to Use This Repository:** This repository is intended for use with the [CDRH API](https://github.com/CDRH/api) and the [To Enter Africa from America Ruby on Rails application](https://github.com/CDRH/teaa).

**Data Repo:** [https://github.com/CDRH/data_teaa](https://github.com/CDRH/data_teaa)

**Source Files:** TEI XML, HTML, CSV, JSON

### Spreadsheets

The personography and Images are populated via CSV's downloaded from Google Sheets: 

### Images

https://docs.google.com/spreadsheets/d/1KN06GKm2XucbCUl49alPFP89GUtJO6hTZ4fQ3urJZlE/edit#gid=0

### Personography

https://docs.google.com/spreadsheets/d/1-Nk0eIBSmQVvV1toGWyGS9Pg_ALbcyPqhE-5nZn1CkY/edit#gid=0

**Script Languages:** Ruby, JavaScript

**Encoding Schema:** [Text Encoding Initiative (TEI) Guidelines](https://tei-c.org/release/doc/tei-p5-doc/en/html/index.html)

## About To Enter Africa from America

To Enter Africa from America: The United States, Africa, and the New Imperialism, 1862-1919 is a collaborative interpretive scholarly work that analyzes American responses to and representations of the exploration and colonization of, migration to, and missionary work in Africa — all of which were part of a larger transnational discourse on the African Question — from 1862 to 1919. The project explores the extent to which American involvement in Africa — whether state-sponsored or as a result of initiatives taken by individuals — contribute to, interact with, influence, and/or complicate U.S. race relations with African Americans.

TEAA takes its title from a passage in the 1877 article "America in Africa" published by Gilbert Haven, a bishop of the Methodist Episcopal Church. He argued that the United States should take an active interest in Africa because European designs on the continent threatened to subjugate Africans and exploit the region's natural resources. Haven called on America to "enter Africa" more vigorously as the United States had both an African presence at home (African Americans) and an American constituency in Africa (Americo-Liberians). Seizing on Haven's notion of "entry" in a theoretical sense, TEAA investigates the various means (physical, political, ideological, religious, and literary), sites, and moments of U.S. engagement with Africa.

As a collaborative digital research project, TEAA utilizes and interprets government documents, periodical materials, literature (plays, poems, and novels) and visual culture (photographs, maps, cartoons, and sketches) to visualize, analyze, and interpret American engagement with the African Question in terms of race, national identity, empire, and modernity.

An earlier iteration of this project was titled Locating Lord Greystoke: U.S. Empire, Race, & the African Question, 1847-1919, at greystoke.unl.edu.

**Project Site:** [https://africafromamerica.unl.edu/](https://africafromamerica.unl.edu/)

**Rails Repo:** [https://github.com/CDRH/teaa](https://github.com/CDRH/teaa)

**Credits:** [https://africafromamerica.unl.edu/about](https://africafromamerica.unl.edu/about)

**Work to Be Done:** [https://github.com/CDRH/teaa/issues](https://github.com/CDRH/teaa/issues)

## Editorial Practice

Project staff transcribed documents using scanned images of the original material. Unless otherwise specified in the metadata, we aim to reproduce the text of each document as exactly as possible. This includes the retention of original spelling and punctuation. Any gaps or uncertain readings of text are marked accordingly. Place names and ethnographic names have not been modernized or corrected and are presented as they appear in the documents.

## Technical Information

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

See project site [Technical information page](https://africafromamerica.unl.edu/about/technical)

See the [Datura documentation](https://github.com/CDRH/datura) for general updating and posting instructions. 

## About the Center for Digital Research in the Humanities

The Center for Digital Research in the Humanities (CDRH) is a joint initiative of the University of Nebraska-Lincoln Libraries and the College of Arts & Sciences. The Center for Digital Research in the Humanities is a community of researchers collaborating to build digital content and systems in order to generate and express knowledge of the humanities. We mentor emerging voices and advance digital futures for all.

**Center for Digital Research in the Humanities GitHub:** [https://github.com/CDRH](https://github.com/CDRH)

**Center for Digital Research in the Humanities Website:** [https://cdrh.unl.edu/](https://cdrh.unl.edu/)
