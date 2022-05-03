#!/bin/bash

sonar-scanner \
  -Dsonar.projectKey=netology \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9009 \
  -Dsonar.login=ac12abaa66bcebaf4dec96e46b3d9cc786775064