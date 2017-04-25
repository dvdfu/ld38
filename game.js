
var Module;

if (typeof Module === 'undefined') Module = eval('(function() { try { return Module || {} } catch(e) { return {} } })()');

if (!Module.expectedDataFileDownloads) {
  Module.expectedDataFileDownloads = 0;
  Module.finishedDataFileDownloads = 0;
}
Module.expectedDataFileDownloads++;
(function() {
 var loadPackage = function(metadata) {

    var PACKAGE_PATH;
    if (typeof window === 'object') {
      PACKAGE_PATH = window['encodeURIComponent'](window.location.pathname.toString().substring(0, window.location.pathname.toString().lastIndexOf('/')) + '/');
    } else if (typeof location !== 'undefined') {
      // worker
      PACKAGE_PATH = encodeURIComponent(location.pathname.toString().substring(0, location.pathname.toString().lastIndexOf('/')) + '/');
    } else {
      throw 'using preloaded data can only be done on a web page or in a web worker';
    }
    var PACKAGE_NAME = 'game.data';
    var REMOTE_PACKAGE_BASE = 'game.data';
    if (typeof Module['locateFilePackage'] === 'function' && !Module['locateFile']) {
      Module['locateFile'] = Module['locateFilePackage'];
      Module.printErr('warning: you defined Module.locateFilePackage, that has been renamed to Module.locateFile (using your locateFilePackage for now)');
    }
    var REMOTE_PACKAGE_NAME = typeof Module['locateFile'] === 'function' ?
                              Module['locateFile'](REMOTE_PACKAGE_BASE) :
                              ((Module['filePackagePrefixURL'] || '') + REMOTE_PACKAGE_BASE);
  
    var REMOTE_PACKAGE_SIZE = metadata.remote_package_size;
    var PACKAGE_UUID = metadata.package_uuid;
  
    function fetchRemotePackage(packageName, packageSize, callback, errback) {
      var xhr = new XMLHttpRequest();
      xhr.open('GET', packageName, true);
      xhr.responseType = 'arraybuffer';
      xhr.onprogress = function(event) {
        var url = packageName;
        var size = packageSize;
        if (event.total) size = event.total;
        if (event.loaded) {
          if (!xhr.addedTotal) {
            xhr.addedTotal = true;
            if (!Module.dataFileDownloads) Module.dataFileDownloads = {};
            Module.dataFileDownloads[url] = {
              loaded: event.loaded,
              total: size
            };
          } else {
            Module.dataFileDownloads[url].loaded = event.loaded;
          }
          var total = 0;
          var loaded = 0;
          var num = 0;
          for (var download in Module.dataFileDownloads) {
          var data = Module.dataFileDownloads[download];
            total += data.total;
            loaded += data.loaded;
            num++;
          }
          total = Math.ceil(total * Module.expectedDataFileDownloads/num);
          if (Module['setStatus']) Module['setStatus']('Downloading data... (' + loaded + '/' + total + ')');
        } else if (!Module.dataFileDownloads) {
          if (Module['setStatus']) Module['setStatus']('Downloading data...');
        }
      };
      xhr.onload = function(event) {
        var packageData = xhr.response;
        callback(packageData);
      };
      xhr.send(null);
    };

    function handleError(error) {
      console.error('package error:', error);
    };
  
      var fetched = null, fetchedCallback = null;
      fetchRemotePackage(REMOTE_PACKAGE_NAME, REMOTE_PACKAGE_SIZE, function(data) {
        if (fetchedCallback) {
          fetchedCallback(data);
          fetchedCallback = null;
        } else {
          fetched = data;
        }
      }, handleError);
    
  function runWithFS() {

    function assert(check, msg) {
      if (!check) throw msg + new Error().stack;
    }
Module['FS_createPath']('/', 'modules', true, true);
Module['FS_createPath']('/modules', 'bump', true, true);
Module['FS_createPath']('/modules', 'hump', true, true);
Module['FS_createPath']('/modules/hump', 'docs', true, true);
Module['FS_createPath']('/modules/hump/docs', '_static', true, true);
Module['FS_createPath']('/modules/hump', 'spec', true, true);
Module['FS_createPath']('/', 'res', true, true);
Module['FS_createPath']('/res', 'fonts', true, true);
Module['FS_createPath']('/res', 'sounds', true, true);
Module['FS_createPath']('/', 'src', true, true);
Module['FS_createPath']('/src', 'objects', true, true);
Module['FS_createPath']('/src', 'states', true, true);

    function DataRequest(start, end, crunched, audio) {
      this.start = start;
      this.end = end;
      this.crunched = crunched;
      this.audio = audio;
    }
    DataRequest.prototype = {
      requests: {},
      open: function(mode, name) {
        this.name = name;
        this.requests[name] = this;
        Module['addRunDependency']('fp ' + this.name);
      },
      send: function() {},
      onload: function() {
        var byteArray = this.byteArray.subarray(this.start, this.end);

          this.finish(byteArray);

      },
      finish: function(byteArray) {
        var that = this;

        Module['FS_createDataFile'](this.name, null, byteArray, true, true, true); // canOwn this data in the filesystem, it is a slide into the heap that will never change
        Module['removeRunDependency']('fp ' + that.name);

        this.requests[this.name] = null;
      },
    };

        var files = metadata.files;
        for (i = 0; i < files.length; ++i) {
          new DataRequest(files[i].start, files[i].end, files[i].crunched, files[i].audio).open('GET', files[i].filename);
        }

  
    function processPackageData(arrayBuffer) {
      Module.finishedDataFileDownloads++;
      assert(arrayBuffer, 'Loading data file failed.');
      assert(arrayBuffer instanceof ArrayBuffer, 'bad input to processPackageData');
      var byteArray = new Uint8Array(arrayBuffer);
      var curr;
      
        // copy the entire loaded file into a spot in the heap. Files will refer to slices in that. They cannot be freed though
        // (we may be allocating before malloc is ready, during startup).
        if (Module['SPLIT_MEMORY']) Module.printErr('warning: you should run the file packager with --no-heap-copy when SPLIT_MEMORY is used, otherwise copying into the heap may fail due to the splitting');
        var ptr = Module['getMemory'](byteArray.length);
        Module['HEAPU8'].set(byteArray, ptr);
        DataRequest.prototype.byteArray = Module['HEAPU8'].subarray(ptr, ptr+byteArray.length);
  
          var files = metadata.files;
          for (i = 0; i < files.length; ++i) {
            DataRequest.prototype.requests[files[i].filename].onload();
          }
              Module['removeRunDependency']('datafile_game.data');

    };
    Module['addRunDependency']('datafile_game.data');
  
    if (!Module.preloadResults) Module.preloadResults = {};
  
      Module.preloadResults[PACKAGE_NAME] = {fromCache: false};
      if (fetched) {
        processPackageData(fetched);
        fetched = null;
      } else {
        fetchedCallback = processPackageData;
      }
    
  }
  if (Module['calledRun']) {
    runWithFS();
  } else {
    if (!Module['preRun']) Module['preRun'] = [];
    Module["preRun"].push(runWithFS); // FS is not initialized yet, wait for it
  }

 }
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 6148, "filename": "/.DS_Store"}, {"audio": 0, "start": 6148, "crunched": 0, "end": 6158, "filename": "/.gitignore"}, {"audio": 0, "start": 6158, "crunched": 0, "end": 6332, "filename": "/.gitmodules"}, {"audio": 0, "start": 6332, "crunched": 0, "end": 6501, "filename": "/conf.lua"}, {"audio": 0, "start": 6501, "crunched": 0, "end": 7119, "filename": "/main.lua"}, {"audio": 0, "start": 7119, "crunched": 0, "end": 7159, "filename": "/modules/bump/.git"}, {"audio": 0, "start": 7159, "crunched": 0, "end": 7168, "filename": "/modules/bump/.gitignore"}, {"audio": 0, "start": 7168, "crunched": 0, "end": 7891, "filename": "/modules/bump/.travis.yml"}, {"audio": 0, "start": 7891, "crunched": 0, "end": 29350, "filename": "/modules/bump/bump.lua"}, {"audio": 0, "start": 29350, "crunched": 0, "end": 30414, "filename": "/modules/bump/MIT-LICENSE.txt"}, {"audio": 0, "start": 30414, "crunched": 0, "end": 30454, "filename": "/modules/hump/.git"}, {"audio": 0, "start": 30454, "crunched": 0, "end": 36521, "filename": "/modules/hump/camera.lua"}, {"audio": 0, "start": 36521, "crunched": 0, "end": 39587, "filename": "/modules/hump/class.lua"}, {"audio": 0, "start": 39587, "crunched": 0, "end": 43120, "filename": "/modules/hump/gamestate.lua"}, {"audio": 0, "start": 43120, "crunched": 0, "end": 45782, "filename": "/modules/hump/signal.lua"}, {"audio": 0, "start": 45782, "crunched": 0, "end": 52315, "filename": "/modules/hump/timer.lua"}, {"audio": 0, "start": 52315, "crunched": 0, "end": 56073, "filename": "/modules/hump/vector-light.lua"}, {"audio": 0, "start": 56073, "crunched": 0, "end": 61592, "filename": "/modules/hump/vector.lua"}, {"audio": 0, "start": 61592, "crunched": 0, "end": 76068, "filename": "/modules/hump/docs/camera.rst"}, {"audio": 0, "start": 76068, "crunched": 0, "end": 85155, "filename": "/modules/hump/docs/class.rst"}, {"audio": 0, "start": 85155, "crunched": 0, "end": 94491, "filename": "/modules/hump/docs/conf.py"}, {"audio": 0, "start": 94491, "crunched": 0, "end": 103614, "filename": "/modules/hump/docs/gamestate.rst"}, {"audio": 0, "start": 103614, "crunched": 0, "end": 104916, "filename": "/modules/hump/docs/index.rst"}, {"audio": 0, "start": 104916, "crunched": 0, "end": 106221, "filename": "/modules/hump/docs/license.rst"}, {"audio": 0, "start": 106221, "crunched": 0, "end": 113622, "filename": "/modules/hump/docs/Makefile"}, {"audio": 0, "start": 113622, "crunched": 0, "end": 118078, "filename": "/modules/hump/docs/signal.rst"}, {"audio": 0, "start": 118078, "crunched": 0, "end": 130898, "filename": "/modules/hump/docs/timer.rst"}, {"audio": 0, "start": 130898, "crunched": 0, "end": 141244, "filename": "/modules/hump/docs/vector-light.rst"}, {"audio": 0, "start": 141244, "crunched": 0, "end": 152050, "filename": "/modules/hump/docs/vector.rst"}, {"audio": 0, "start": 152050, "crunched": 0, "end": 159024, "filename": "/modules/hump/docs/_static/graph-tweens.js"}, {"audio": 0, "start": 159024, "crunched": 0, "end": 261860, "filename": "/modules/hump/docs/_static/in-out-interpolators.png"}, {"audio": 0, "start": 261860, "crunched": 0, "end": 358624, "filename": "/modules/hump/docs/_static/interpolators.png"}, {"audio": 0, "start": 358624, "crunched": 0, "end": 414100, "filename": "/modules/hump/docs/_static/inv-interpolators.png"}, {"audio": 0, "start": 414100, "crunched": 0, "end": 427525, "filename": "/modules/hump/docs/_static/vector-cross.png"}, {"audio": 0, "start": 427525, "crunched": 0, "end": 440631, "filename": "/modules/hump/docs/_static/vector-mirrorOn.png"}, {"audio": 0, "start": 440631, "crunched": 0, "end": 454399, "filename": "/modules/hump/docs/_static/vector-perpendicular.png"}, {"audio": 0, "start": 454399, "crunched": 0, "end": 484306, "filename": "/modules/hump/docs/_static/vector-projectOn.png"}, {"audio": 0, "start": 484306, "crunched": 0, "end": 496988, "filename": "/modules/hump/docs/_static/vector-rotated.png"}, {"audio": 0, "start": 496988, "crunched": 0, "end": 498617, "filename": "/modules/hump/spec/timer_spec.lua"}, {"audio": 0, "start": 498617, "crunched": 0, "end": 506109, "filename": "/res/background.png"}, {"audio": 0, "start": 506109, "crunched": 0, "end": 569565, "filename": "/res/background_blur.png"}, {"audio": 0, "start": 569565, "crunched": 0, "end": 569680, "filename": "/res/bee.png"}, {"audio": 0, "start": 569680, "crunched": 0, "end": 569802, "filename": "/res/bee_dead.png"}, {"audio": 0, "start": 569802, "crunched": 0, "end": 569921, "filename": "/res/bee_wings.png"}, {"audio": 0, "start": 569921, "crunched": 0, "end": 570125, "filename": "/res/cursor.png"}, {"audio": 0, "start": 570125, "crunched": 0, "end": 570340, "filename": "/res/dandelion_core.png"}, {"audio": 0, "start": 570340, "crunched": 0, "end": 572060, "filename": "/res/dandelion_puff.png"}, {"audio": 0, "start": 572060, "crunched": 0, "end": 572428, "filename": "/res/droplet.png"}, {"audio": 0, "start": 572428, "crunched": 0, "end": 572534, "filename": "/res/droplet_small.png"}, {"audio": 0, "start": 572534, "crunched": 0, "end": 581485, "filename": "/res/ending_death.png"}, {"audio": 0, "start": 581485, "crunched": 0, "end": 597036, "filename": "/res/ending_swarm.png"}, {"audio": 0, "start": 597036, "crunched": 0, "end": 597846, "filename": "/res/flower_petals.png"}, {"audio": 0, "start": 597846, "crunched": 0, "end": 598067, "filename": "/res/flower_pollen.png"}, {"audio": 0, "start": 598067, "crunched": 0, "end": 598294, "filename": "/res/flower_stamen.png"}, {"audio": 0, "start": 598294, "crunched": 0, "end": 598670, "filename": "/res/flower_stem.png"}, {"audio": 0, "start": 598670, "crunched": 0, "end": 599235, "filename": "/res/fly_body.png"}, {"audio": 0, "start": 599235, "crunched": 0, "end": 599483, "filename": "/res/fly_legs.png"}, {"audio": 0, "start": 599483, "crunched": 0, "end": 599890, "filename": "/res/fly_wings.png"}, {"audio": 0, "start": 599890, "crunched": 0, "end": 604673, "filename": "/res/foreground.png"}, {"audio": 0, "start": 604673, "crunched": 0, "end": 650345, "filename": "/res/foreground_blur.png"}, {"audio": 0, "start": 650345, "crunched": 0, "end": 651754, "filename": "/res/frog.png"}, {"audio": 0, "start": 651754, "crunched": 0, "end": 651858, "filename": "/res/frog_eye.png"}, {"audio": 0, "start": 651858, "crunched": 0, "end": 652463, "filename": "/res/frog_mouth.png"}, {"audio": 0, "start": 652463, "crunched": 0, "end": 652570, "filename": "/res/frog_tongue.png"}, {"audio": 0, "start": 652570, "crunched": 0, "end": 652833, "filename": "/res/frog_tongue_tip.png"}, {"audio": 0, "start": 652833, "crunched": 0, "end": 653093, "filename": "/res/grass_1.png"}, {"audio": 0, "start": 653093, "crunched": 0, "end": 653349, "filename": "/res/grass_2.png"}, {"audio": 0, "start": 653349, "crunched": 0, "end": 653561, "filename": "/res/hud_bee.png"}, {"audio": 0, "start": 653561, "crunched": 0, "end": 653780, "filename": "/res/hud_tree.png"}, {"audio": 0, "start": 653780, "crunched": 0, "end": 654516, "filename": "/res/raindrop_large.png"}, {"audio": 0, "start": 654516, "crunched": 0, "end": 654989, "filename": "/res/raindrop_medium.png"}, {"audio": 0, "start": 654989, "crunched": 0, "end": 655198, "filename": "/res/raindrop_particle.png"}, {"audio": 0, "start": 655198, "crunched": 0, "end": 655434, "filename": "/res/raindrop_small.png"}, {"audio": 0, "start": 655434, "crunched": 0, "end": 656725, "filename": "/res/raindrop_splash.png"}, {"audio": 0, "start": 656725, "crunched": 0, "end": 660656, "filename": "/res/title_logo.png"}, {"audio": 0, "start": 660656, "crunched": 0, "end": 663284, "filename": "/res/tree.png"}, {"audio": 0, "start": 663284, "crunched": 0, "end": 663692, "filename": "/res/tree_branch.png"}, {"audio": 0, "start": 663692, "crunched": 0, "end": 664378, "filename": "/res/tree_hive.png"}, {"audio": 0, "start": 664378, "crunched": 0, "end": 667123, "filename": "/res/yellow_puff.png"}, {"audio": 0, "start": 667123, "crunched": 0, "end": 716555, "filename": "/res/fonts/redalert.ttf"}, {"audio": 1, "start": 716555, "crunched": 0, "end": 1772501, "filename": "/res/sounds/bee_ambient.mp3"}, {"audio": 1, "start": 1772501, "crunched": 0, "end": 2514655, "filename": "/res/sounds/bee_calm.mp3"}, {"audio": 1, "start": 2514655, "crunched": 0, "end": 3587637, "filename": "/res/sounds/bee_dangerous.mp3"}, {"audio": 1, "start": 3587637, "crunched": 0, "end": 3615841, "filename": "/res/sounds/droplet.wav"}, {"audio": 1, "start": 3615841, "crunched": 0, "end": 3828472, "filename": "/res/sounds/rain.mp3"}, {"audio": 1, "start": 3828472, "crunched": 0, "end": 3880496, "filename": "/res/sounds/ribbit.wav"}, {"audio": 1, "start": 3880496, "crunched": 0, "end": 3951854, "filename": "/res/sounds/thunder.mp3"}, {"audio": 0, "start": 3951854, "crunched": 0, "end": 3953304, "filename": "/src/animation.lua"}, {"audio": 0, "start": 3953304, "crunched": 0, "end": 3954817, "filename": "/src/camera.lua"}, {"audio": 0, "start": 3954817, "crunched": 0, "end": 3958947, "filename": "/src/chunkSpawner.lua"}, {"audio": 0, "start": 3958947, "crunched": 0, "end": 3959146, "filename": "/src/constants.lua"}, {"audio": 0, "start": 3959146, "crunched": 0, "end": 3962171, "filename": "/src/music.lua"}, {"audio": 0, "start": 3962171, "crunched": 0, "end": 3963225, "filename": "/src/objects.lua"}, {"audio": 0, "start": 3963225, "crunched": 0, "end": 3964340, "filename": "/src/rain.lua"}, {"audio": 0, "start": 3964340, "crunched": 0, "end": 3968334, "filename": "/src/objects/bee.lua"}, {"audio": 0, "start": 3968334, "crunched": 0, "end": 3970990, "filename": "/src/objects/dandelion.lua"}, {"audio": 0, "start": 3970990, "crunched": 0, "end": 3973006, "filename": "/src/objects/enemy.lua"}, {"audio": 0, "start": 3973006, "crunched": 0, "end": 3977844, "filename": "/src/objects/flower.lua"}, {"audio": 0, "start": 3977844, "crunched": 0, "end": 3979734, "filename": "/src/objects/fly.lua"}, {"audio": 0, "start": 3979734, "crunched": 0, "end": 3984519, "filename": "/src/objects/frog.lua"}, {"audio": 0, "start": 3984519, "crunched": 0, "end": 3985176, "filename": "/src/objects/object.lua"}, {"audio": 0, "start": 3985176, "crunched": 0, "end": 3989144, "filename": "/src/objects/player.lua"}, {"audio": 0, "start": 3989144, "crunched": 0, "end": 3991339, "filename": "/src/objects/raindrop.lua"}, {"audio": 0, "start": 3991339, "crunched": 0, "end": 3994450, "filename": "/src/objects/tree.lua"}, {"audio": 0, "start": 3994450, "crunched": 0, "end": 3996727, "filename": "/src/states/dead.lua"}, {"audio": 0, "start": 3996727, "crunched": 0, "end": 3998503, "filename": "/src/states/finale.lua"}, {"audio": 0, "start": 3998503, "crunched": 0, "end": 4005766, "filename": "/src/states/game.lua"}, {"audio": 0, "start": 4005766, "crunched": 0, "end": 4008210, "filename": "/src/states/intro.lua"}, {"audio": 0, "start": 4008210, "crunched": 0, "end": 4009711, "filename": "/src/states/transition.lua"}], "remote_package_size": 4009711, "package_uuid": "49c6a9a9-d4f4-4f71-ae62-730cf2ac45e9"});

})();
