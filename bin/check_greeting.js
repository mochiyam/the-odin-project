// bin/check_greeting.js
const fs = require('fs');

// 1. Read the file
const content = fs.readFileSync('greeting.txt', 'utf-8');

// 2. Check the rule
if (content.includes('Hello')) {
  console.log('Success: The greeting is correct!');
  process.exit(0); // GREEN LIGHT: Tell GitHub it passed
} else {
  console.error('Error: The file is missing the word "Hello"!');
  process.exit(1); // RED LIGHT: Tell GitHub to fail the PR
}