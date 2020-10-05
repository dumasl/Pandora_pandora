if [ "x${TRAVIS_REPO_SLUG}" = "xdumasl/Pandora_pandora" ]; then
    openssl aes-256-cbc -K $encrypted_8ebb1ef83f64_key -iv $encrypted_8ebb1ef83f64_iv -in .travis/github_deploy_key.enc -out github_deploy_key -d
    chmod 600 github_deploy_key
    eval `ssh-agent -s`
    ssh-add github_deploy_key

    cd "$TRAVIS_BUILD_DIR"
    docker run -v $TRAVIS_BUILD_DIR:/data ldumas/pandora_build_env:ubuntu19.10-python3.7-pages /bin/sh -c "cd /data; . ./venv/bin/activate; cd doc; make html; chmod -R 777 build"
    cd $TRAVIS_BUILD_DIR/doc/build/html/                           
    touch .nojekyll
    git init
    git checkout -b gh-pages
    git add -f .
    git -c user.name='travis' -c user.email='travis' commit -m init
    git push -q -f git@github.com:${TRAVIS_REPO_SLUG}.git gh-pages &2>/dev/null
    cd "$TRAVIS_BUILD_DIR"
fi