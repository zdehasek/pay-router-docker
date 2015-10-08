#!/bin/bash

cd /app
#git pull origin beta
git pull origin dev
npm install --production
node ./bin/production.js
