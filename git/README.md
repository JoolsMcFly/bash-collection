# rename-branch.sh
Simple script to rename branches and push them to remote

# pre-commit-hook.sh
Following assumptions are made:
- you have [PHP CS Fixer](https://github.com/FriendsOfPHP/PHP-CS-Fixer) installed
- you have a .php_cs file at the root of your project
- you use docker

#### Usage
- Add this script to the root of your project and make sure it's executable (chmod +x pre-commit-hook.sh)
- install [Pre Commit Hook Plugin](https://plugins.jetbrains.com/plugin/9278-pre-commit-hook-plugin) in Phpstorm
- now if you commit files that do not comply with php-cs-fixer's rules Phpstorm will display a warning asking you to confirm your commit.

#### but I don't use docker!
OK, even though you should, using this hook without docker is as simple as changing
```bash
results=`docker exec -i DOCKER_CONTAINER_NAME ./php-cs-fixer-v2.phar fix $file --dry-run 2>/dev/null | head -n -2`
```

to

```bash
results=`./php-cs-fixer-v2.phar fix $file --dry-run 2>/dev/null | head -n -2`
```

# deploy.sh
Script I wrote to ease pushing to dev/staging/prod sites of our Symfony application.
All three versions run on the same server but you can esily adapt the rsync command to push to different servers.
Script works as follows:
- lists available branches, most recently updated first
- asks where to deploy (dev/staging/prod)
- asks for confirmation before proceeding

Once you've confirmed it will
- run composer install
- run `yarn run build` to build assets
- run migrations
- update `templates/branch-version.html.twig` which shows deployment information
- clear cache and chmod directories
