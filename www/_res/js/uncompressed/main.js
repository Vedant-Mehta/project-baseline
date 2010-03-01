/**
 *  @author MRaichelson
 */

// Reassign jQuery $() to avoid namespace collisions
$j = jQuery.noConflict();



/*  Application of code:
 *  this file should be referenced at the end of the document so this
 *  is where code normally wraped in $(doc).ready() goes.
 */

// IE-specific code
if($j.browser.msie){
  $j('table.zebra').each(function(i){
    $j('tr:nth-child(even)',this).addClass('even');
    $j('tr:nth-child(odd)',this).addClass('odd');
  });
  $j('ul,ol').each(function(i){
    $j('li:first',this).addClass('first-child');
    $j('li:last',this).addClass('last-child');
  });
}
// end of IE-specific code