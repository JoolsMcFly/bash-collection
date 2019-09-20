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

### bash or sh?!
If you have eagle eyes you've probably noticed the script's extension is `sh` but the actual script uses `bash`. 

The plugin requires the hook file to be exactly `pre-commit-hook.sh` but nothing stops you from changing the shebang to something that better suits you. That's what I did!
