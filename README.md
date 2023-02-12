## Laravel Deployment and Nginx Server setup using one file

## Some commands may not be executed successfully due to permission issue.

This file is built for root user not others. To modify for others users , simply add 'sudo' as prefix
of every command
Issues and Security: This file is built for only single use. You are also free to use at your **_own risk_**.

#### Step1: Download the all files in your machine and unzip inside <i>/var/www</i> directory <br>

#### Step2: Run command

 <pre>nano script.sh</pre>

#### Step3: edit <i>script.sh</i> with project name and <i>ssh-url</i> of your git repository

#### Step 4: save it using


<ul>
  <li>Ctrl +X </li>
  <li>Y</li>
  <li>Enter</li>
</ul>

#### Step 5: Add Execute Permission to _script.sh_ file

 <pre>chmod +x script.sh</pre>

#### Step 6: run

 <pre>./script.sh</pre>

# Install and Tasks

 <pre>
  >  SSH Key Generate
  >  php
  >  install composer
  >  nginx
  >  permission to  folders
  >  clone repository
  >  generate ssh-key
  >  assign laravel permission(for laravel permission use <strong>laravel.sh</strong> repeating 1-6 step )
 </pre>

 <h1 style="color: red !important"> *You are fully responsible for if any damage happened in server due to use of this bash script. So, use it at your own risk*</h1>

<img src="https://raw.githubusercontent.com/arif98741/laravelbash/master/screenshot.jpg"><img src="https://raw.githubusercontent.com/arif98741/laravelbash/master/screenshot2.jpg">
