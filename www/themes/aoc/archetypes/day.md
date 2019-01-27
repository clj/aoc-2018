---
title: "Day {{ strings.TrimPrefix "0" (replace .Name "-" " ") | title }}"
date: {{ .Date }}
draft: true
---

# Day {{ strings.TrimPrefix "0" (replace .Name "-" " ") | title }}: