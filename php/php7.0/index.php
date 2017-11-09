<?php
/**
 * Copyright (c) 2017 Eclipse Foundation and others.
 * 
 * This program and the accompanying materials are made 
 * available under the terms of the Eclipse Public License 2.0 
 * which accompanies this distribution, and is available
 * at http://eclipse.org/legal/epl-2.0
*/

if (file_exists('oxygen/index.php')) {
  include_once('oxygen/index.php');
  exit();
}
else if (file_exists('home/index.php')) {
  include_once('home/index.php');
  exit();
}

phpinfo();