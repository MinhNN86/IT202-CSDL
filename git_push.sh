#!/bin/bash

# Kiểm tra có phải repo git không
if [ ! -d ".git" ]; then
  echo "❌ Thư mục này không phải Git repository"
  exit 1
fi

BRANCH=$(git branch --show-current)
echo "📌 Branch hiện tại: $BRANCH"

# Hỏi commit message
echo -n "✍️  Nhập commit message: "
read COMMIT_MSG

if [ -z "$COMMIT_MSG" ]; then
  echo "❌ Commit message không được để trống"
  exit 1
fi

git add .
git commit -m "$COMMIT_MSG"
git push origin $BRANCH

echo "✅ Push thành công!"
