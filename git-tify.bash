#! /usr/bin/env bash

################################################################################
##
## This file is part of RaSt git-gnu-project.
##
## RaSt git-gnu-project is to  manage a directory as a Git  repository and a GNU
## package.
##
## Copyright (C)  2023  Ralf Stephan
##
## RaSt git-gnu-project is free software:  you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by the Free
## Software Foundation, either version 3 of the License, or (at your option) any
## later version.
##
## RaSt git-gnu-project is  distributed in the hope that it  will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR  A PARTICULAR PURPOSE.   See the  GNU General Public  License for
## more details.
##
## You should have received a copy of  the GNU General Public License along with
## this program.  If not, see <https://www.gnu.org/licenses/>.
##
################################################################################



################################################################################
##
## $Date: 2023-06-05 12:11:58.1852606000 +00:00:00 $
##
################################################################################



################################################################################
##
## git-tify.bash (git-gnu-project)
##
## NAME
##
## git-tify.bash - manage a directory as a Git repository
##
## LIBRARY                                      (For sections 2, 3, and 9 only.)
##
## SYNOPSIS
##
## git-tify.bash repository-path repository-name ???
##
## DESCRIPTION
##
## ???
##
## ARGUMENTS
##
## repository-path - path to the directory
##
## repository-name - name of the repository
##
## ???
##
## OPTIONS
##
## ???
##
## CONTEXT                                       (For section 9 functions only.)
##
## IMPLEMENTATION NOTES
##
## RETURN VALUES         (For sections 2, 3, and 9 function return values only.)
##
## ENVIRONMENT                               (For sections 1, 6, 7, and 8 only.)
##
## FILES
##
## git-tify.bash - this script
##
## EXIT STATUS                                  (For sections 1, 6, and 8 only.)
##
## EXAMPLES
##
## git-tify.bash /home/user/john_dow/repositories/ foobar
##
## DIAGNOSTICS  (For sections 1, 4, 6, 7, 8, and 9 printf/stderr messages only.)
##
## ERRORS                     (For sections 2, 3, 4, and 9 errno settings only.)
##
## SEE ALSO
##
## STANDARDS
##
## HISTORY
##
## AUTHORS
##
## Ralf Stephan <me@ralf-stephan.name>
##
## CAVEATS
##
## BUGS
##
## SECURITY CONSIDERATIONS
##
## TESTS
##
## See section TESTS below.
##
################################################################################



################################################################################
##
## Global constants.
##
################################################################################



################################################################################
##
## Global variables.
##
################################################################################
##
## command line argument $1 : repository-path - path to the directory
##
declare repository_path='';
##
## command line argument S2 : repository-name - name of the repository
##
declare repository_name='';
##
## command line argument $3 : user name
##
declare user_name='';
##
## command line argument $4 : user email
##
declare user_email='';
##
## command line argument $5 : how a merge is handled
##
## git merge --ff-only : merge.ff = only
## git merge --ff      : merge.ff = true
## git merge --no-ff   : merge.ff = false
##
declare merge_ff='';
##
## command line argument $6 : how a pull is handled
##
## git pull --ff-only : pull.ff = only
## git pull --ff      : pull.ff = true
## git pull --no-ff   : pull.ff = false
##
declare pull_ff='';
##
## command line argument $7 : remotes url
##
declare -a remotes=();
##
## command line argument $8 : project name
##
declare project_name='';
##
## command line argument $9 : package name
##
declare package_name='';
##
## command line argument $10 : Git configuration files.
##
declare -a git_files=();



## command line argument ??? : how a rebase is handled
##
## git pull --rebase='false'       : pull.rebase = false
## git pull --rebase='true'        : pull.rebase = true
## git pull --rebase='interactive' : pull.rebase = interactive
## git pull --rebase='merges'      : pull.rebase = merges
##
declare pull_rebase=''; # unused



################################################################################
##
## Get the command line arguments.
##
################################################################################
##
## Check number of arguments.
##
if (( 10 == "${#}" )); then
  :;
else
  echo 'Error: wrong number of arguments.';
  exit 1;
fi
##
## command line argument $1 : repository-path - path to the directory
##
repository_path="${1}";
repository_path="$( echo "${repository_path}" | sed 's/[/]*$//g' )";
                                                                                #echo "repository_path : '${repository_path}'";
##
## command line argument S2 : repository-name - name of the repository
##
repository_name="${2}";
                                                                                #echo "repository_name : '${repository_name}'";
##
## command line argument $3 : user name
##
user_name="${3}";
                                                                                #echo "user_name       : '${user_name}'";
##
## command line argument $4 : user email
##
user_email="${4}";
                                                                                #echo "user_email      : '${user_email}'";
##
## command line argument $5 : how a merge is handled
##
merge_ff="${5}";
                                                                                #echo "merge_ff        : '${merge_ff}'";
##
## command line argument $6 : how a pull is handled
##
pull_ff="${6}";
                                                                                #echo "pull_ff         : '${pull_ff}'";
##
## command line argument $7 : remotes
##
IFS=';' read -a 'remotes' -r <<< "${7}";
                                                                                #echo "remotes         : '${remotes[@]}' (${#remotes[@]})";
##
## command line argument $8 : project name
##
project_name="${8}";
                                                                                #echo "project_name    : '${project_name}'";
##
## command line argument $9 : package name
##
package_name="${9}";
                                                                                #echo "package_name    : '${package_name}'";
##
## command line argument $10 : Git configuration files.
##
IFS=';' read -a 'git_files' -r <<< "${10}";
                                                                                #echo "git_files       : '${git_files[@]}' (${#git_files[@]})";



################################################################################
##
## See if we can create a new Git repository.  If OK, then change working
## directory and create the new directory.
##
################################################################################
##
## See if there is the directory $repository_path.
##
if [[ -d "${repository_path}/" ]]; then
  :;
else
  echo "Error: directory '${repository_path}/' does not exist.";
  exit 1;
fi
##
cd "${repository_path}/";
##
## See if there is a directory $repository_name is directory $repository_path.
##
if [[ -d "./${repository_name}/" ]]; then
  echo "Error: directory '${repository_path}/${repository_name}/' does exist.";
  exit 1;
else
  :;
fi
##
mkdir "./${repository_name}/";
##
cd "./${repository_name}/";



################################################################################
##
## Create and initialize an empty Git repository in the working directory.
##
################################################################################
##
echo "Info: create and initialize an empty repository in '${repository_path}/${repository_name}/'. ...";
##
git init --initial-branch='master' --template='' './';
##
echo '... done';



################################################################################
##
## Configure the Git repository.
##
################################################################################
##
echo "Info: configuring repository '${repository_path}/${repository_name}/'. ...";
##
git config --global user.name  "${user_name}";
##
git config          user.name  "${user_name}";
##
git config --global user.email "${user_email}";
##
git config          user.email "${user_email}";
##
git config --global merge.ff   "${merge_ff}";
##
git config          merge.ff   "${merge_ff}";
##
git config --global pull.ff    "${pull_ff}";
##
git config          pull.ff    "${pull_ff}";
##
declare remote='';
declare -a key_value=();
for remote in "${remotes[@]}"; do
  key_value=();
  IFS=',' read -a 'key_value' -r <<< "${remote}";
  git remote add "${key_value[0]}" "${key_value[1]}";
done;
##
echo '... done';



################################################################################
##
## Initial commit of the repository.
##
################################################################################
##
echo "Info: committing as initial commit '${REPOSITORY}'. ...";
##
git commit --allow-empty --message="$( echo "Initial commit of ${project_name} ${package_name}." | fold --spaces --width='50' )";
##
echo '... done';



################################################################################
##
## Create und commit Git configuration files.
##
################################################################################
##
echo "Info: creating git configuration files in '${REPOSITORY}'. ...";
##
declare git_file='';
for git_file in "${git_files[@]}"; do
  touch "./${git_file}";
  git add "./${git_file}";
  git commit --message="$( echo "Add Git configuration file." | fold --spaces  --width='50' )

$( echo "* ${git_file}: add configuration file." | fold --spaces  --width='72' )";
done
##
echo '... done';



################################################################################
##
## TESTS
##
################################################################################



################################################################################
##
## Exit the shell.
##
################################################################################

exit 0;
