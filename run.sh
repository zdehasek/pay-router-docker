#!/bin/bash

cd /app
git pull origin beta
npm install --production
node ./bin/production.js