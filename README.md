# bash-collection
Series of bash scripts I find useful

## pre-commit-hook.sh
Following assumptions are made:
- you have [PHP CS Fixer](https://github.com/FriendsOfPHP/PHP-CS-Fixer) installed
- you have a .php_cs file at the root of your project
- you use docker

### Usage
- Add this script to the root of your project and make sure it's executable (chmod +x pre-commit-hook.sh)
- install [Pre Commit Hook Plugin](https://plugins.jetbrains.com/plugin/9278-pre-commit-hook-plugin) in Phpstorm
- now if you commit files that do not comply with php-cs-fixer's rules Phpstorm will display a warning asking you to confirm your commit.

### but I don't use docker!
OK, even though you should, using this hook without docker is as simple as changing
```bash
results=`docker exec -i DOCKER_CONTAINER_NAME ./php-cs-fixer-v2.phar fix $file --dry-run 2>/dev/null | head -n -2`
```

to

```bash
results=`./php-cs-fixer-v2.phar fix $file --dry-run 2>/dev/null | head -n -2`
```
