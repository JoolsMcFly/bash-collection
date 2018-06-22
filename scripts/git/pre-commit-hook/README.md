### Assumptions
- you have [PHP CS Fixer](https://github.com/FriendsOfPHP/PHP-CS-Fixer) installed
- you use docker

### I don't use docker!
OK, even though you should, using this hook without docker is as simple as changing
```bash
results=`docker exec -i DOCKER_CONTAINER_NAME ./php-cs-fixer-v2.phar fix $file --dry-run 2>/dev/null | head -n -2`
```

to

```bash
results=`./php-cs-fixer-v2.phar fix $file --dry-run 2>/dev/null | head -n -2`
```

### Usage
- add `pre-commit-hook.sh` script to the root of your project and make sure it's executable: `chmod +x pre-commit-hook.sh`
- install [Pre Commit Hook Plugin](https://plugins.jetbrains.com/plugin/9278-pre-commit-hook-plugin) in Phpstorm

Now if you commit files that do not comply with php-cs-fixer's rules Phpstorm will display a warning asking you to confirm your commit.
It will also show you the command to run to fix all the files in one go.
