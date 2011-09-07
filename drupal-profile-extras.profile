<?php

// Place in your PROFILENAME.profile file.

/**
 * Set PROFILENAME as default selected install profile.
 *
 * This is mean, but if you're the only install profile around,
 * it's probably acceptable. I wouldn't recommend committing this
 * to a d.o install profile.
 */
function system_form_install_select_profile_form_alter(&$form, $form_state) {
  foreach($form['profile'] as $key => $element) {
    $form['profile'][$key]['#value'] = 'PROFILENAME';
  }
}

/**
 * Implements hook_install_tasks().
 *
 * Allows the user to select the features to be enabled during the install.
 * @see: PROFILENAME_select_features_form()
 * @see: PROFILENAME_select_features_form_submit()
 */
function PROFILENAME_install_tasks() {
  $tasks['PROFILENAME_select_features_form'] = array(
    'display_name' => st('Select features'),
    'display' => TRUE,
    'type' => 'form',
    'run' => INSTALL_TASK_RUN_IF_NOT_COMPLETED,
  );
  return $tasks;
}

/**
 * Task callback: returns form to select features.
 */
function PROFILENAME_select_features_form() {
  $form = array();
  
  // Load the form from features module
  module_load_include('inc', 'features', 'features.admin');
  $form = drupal_get_form('features_admin_form');
  
  // Remove the vertical tabs on known groups.
  unset($form['features']['#group']);

  // We dont want to allow people to 'recreate' a feature
  unset($form['features']['actions']);
  
  // Remove the buttons and add our own actions.
  unset($form['buttons']);  
  $form['actions'] = array('#type' => 'actions');
  $form['actions']['submit'] = array(
    '#type' => 'submit',
    '#value' => st('Submit'),
    '#weight' => 99,
  );
  
  // Remove any submit and validate handlers so that default is used.
  unset($form['#submit']);
  unset($form['#validate']);

  return $form;
}

/**
 * Submit handler for select_features_form.
 */
function PROFILENAME_select_features_form_submit(&$form, &$form_state) {
  // Features is odd, just trust me on this one.
  foreach ($form_state['input']['status'] as $module => $status) {
    $form_state['values']['status'][$module] = $status;
  }
  
  // Submit the form to features.
  module_load_include('inc', 'features', 'features.admin');
  features_form_submit($form, $form_state);
  
  // Features_form_submit adds a redirect, we don't want it.
  unset($form_state['redirect']);
}

/**
 * Implements hook_form_FORM_ID_alter().
 *
 * If you want to alter any site information, such as default
 * site name, mail, admin account, etc, do so here.
 * 
 * Allows the profile to alter the site configuration form.
 */
function PROFILENAME_form_install_configure_form_alter(&$form, $form_state) {
  //$form['site_information']['site_name']['#default_value'] = 'My site name';
  //$form['site_information']['site_mail']['#default_value'] = 'email@example.com';
  //$form['admin_account']['account']['name']['#default_value'] = 'admin';
  //$form['admin_account']['account']['mail']['#default_value'] = 'admin-email@example.com';
  //$form['server_settings']['site_default_country']['#default_value'] = 'US';
}