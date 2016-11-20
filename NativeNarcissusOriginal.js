// This file is used as a reference
// The file in src/Native/Narcissus.js is already compiled via webpack
// Currently this is using narcissus 1.0.0
// I am looking for a better way to do this... but it appears that the
// elm-packager requires packages to be on github... so I don't want to waste
// too much space by including webpack files, etc...

// Expect narcissus in the global scope?
const narcissus = require('narcissus');

// Parses the list to an object that narcissus can understand
function objectFromListOfStyles(list) {
  const array = _elm_lang$core$Native_List.toArray(list);

  const object = {};

  array.forEach(function(datum) {
    // Access into StringStyle or IntStyle
    const item = datum._0;
    const key = item._0;
    const value = item._1;

    if (typeof value === 'object') {
      if (value.ctor === '::') {
        // For nested styles
        const transformedValue = objectFromListOfStyles(value);
        object[key] = transformedValue;
      }
    } else {
      object[key] = value;
    }
  });

  return object;
}

var _user$project$Native_Narcissus = function(a, b, c) {
  function inject(list) {
    // Turn that list into an array
    const object = objectFromListOfStyles(list);
    const inject = narcissus.inject;
    return inject(object);
  }

  return {
    inject: inject,
  }
}();

// We have to attach this to the window (or another global) because webpack
// scopes all of its output so no variables bleed into the global scope
window._user$project$Native_Narcissus = _user$project$Native_Narcissus;
