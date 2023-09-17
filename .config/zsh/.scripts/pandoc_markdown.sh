#!/bin/bash

FRONTMATTER=$"---
geometry: \"left=3cm, right=3cm, top=3cm, bottom=2cm\"
fontsize: \"12pt\"
papersize: \"letter\"
---
# Placeholder Title
"
echo "$FRONTMATTER" >> $1
