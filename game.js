
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
 loadPackage({"files": [{"audio": 0, "start": 0, "crunched": 0, "end": 10, "filename": "/.gitignore"}, {"audio": 0, "start": 10, "crunched": 0, "end": 184, "filename": "/.gitmodules"}, {"audio": 0, "start": 184, "crunched": 0, "end": 353, "filename": "/conf.lua"}, {"audio": 0, "start": 353, "crunched": 0, "end": 1076, "filename": "/main.lua"}, {"audio": 0, "start": 1076, "crunched": 0, "end": 7224, "filename": "/modules/.DS_Store"}, {"audio": 0, "start": 7224, "crunched": 0, "end": 13372, "filename": "/modules/bump/.DS_Store"}, {"audio": 0, "start": 13372, "crunched": 0, "end": 13412, "filename": "/modules/bump/.git"}, {"audio": 0, "start": 13412, "crunched": 0, "end": 13421, "filename": "/modules/bump/.gitignore"}, {"audio": 0, "start": 13421, "crunched": 0, "end": 14144, "filename": "/modules/bump/.travis.yml"}, {"audio": 0, "start": 14144, "crunched": 0, "end": 35603, "filename": "/modules/bump/bump.lua"}, {"audio": 0, "start": 35603, "crunched": 0, "end": 36667, "filename": "/modules/bump/MIT-LICENSE.txt"}, {"audio": 0, "start": 36667, "crunched": 0, "end": 42815, "filename": "/modules/hump/.DS_Store"}, {"audio": 0, "start": 42815, "crunched": 0, "end": 42855, "filename": "/modules/hump/.git"}, {"audio": 0, "start": 42855, "crunched": 0, "end": 48922, "filename": "/modules/hump/camera.lua"}, {"audio": 0, "start": 48922, "crunched": 0, "end": 51988, "filename": "/modules/hump/class.lua"}, {"audio": 0, "start": 51988, "crunched": 0, "end": 55521, "filename": "/modules/hump/gamestate.lua"}, {"audio": 0, "start": 55521, "crunched": 0, "end": 58183, "filename": "/modules/hump/signal.lua"}, {"audio": 0, "start": 58183, "crunched": 0, "end": 64716, "filename": "/modules/hump/timer.lua"}, {"audio": 0, "start": 64716, "crunched": 0, "end": 68474, "filename": "/modules/hump/vector-light.lua"}, {"audio": 0, "start": 68474, "crunched": 0, "end": 73993, "filename": "/modules/hump/vector.lua"}, {"audio": 0, "start": 73993, "crunched": 0, "end": 88469, "filename": "/modules/hump/docs/camera.rst"}, {"audio": 0, "start": 88469, "crunched": 0, "end": 97556, "filename": "/modules/hump/docs/class.rst"}, {"audio": 0, "start": 97556, "crunched": 0, "end": 106892, "filename": "/modules/hump/docs/conf.py"}, {"audio": 0, "start": 106892, "crunched": 0, "end": 116015, "filename": "/modules/hump/docs/gamestate.rst"}, {"audio": 0, "start": 116015, "crunched": 0, "end": 117317, "filename": "/modules/hump/docs/index.rst"}, {"audio": 0, "start": 117317, "crunched": 0, "end": 118622, "filename": "/modules/hump/docs/license.rst"}, {"audio": 0, "start": 118622, "crunched": 0, "end": 126023, "filename": "/modules/hump/docs/Makefile"}, {"audio": 0, "start": 126023, "crunched": 0, "end": 130479, "filename": "/modules/hump/docs/signal.rst"}, {"audio": 0, "start": 130479, "crunched": 0, "end": 143299, "filename": "/modules/hump/docs/timer.rst"}, {"audio": 0, "start": 143299, "crunched": 0, "end": 153645, "filename": "/modules/hump/docs/vector-light.rst"}, {"audio": 0, "start": 153645, "crunched": 0, "end": 164451, "filename": "/modules/hump/docs/vector.rst"}, {"audio": 0, "start": 164451, "crunched": 0, "end": 171425, "filename": "/modules/hump/docs/_static/graph-tweens.js"}, {"audio": 0, "start": 171425, "crunched": 0, "end": 274261, "filename": "/modules/hump/docs/_static/in-out-interpolators.png"}, {"audio": 0, "start": 274261, "crunched": 0, "end": 371025, "filename": "/modules/hump/docs/_static/interpolators.png"}, {"audio": 0, "start": 371025, "crunched": 0, "end": 426501, "filename": "/modules/hump/docs/_static/inv-interpolators.png"}, {"audio": 0, "start": 426501, "crunched": 0, "end": 439926, "filename": "/modules/hump/docs/_static/vector-cross.png"}, {"audio": 0, "start": 439926, "crunched": 0, "end": 453032, "filename": "/modules/hump/docs/_static/vector-mirrorOn.png"}, {"audio": 0, "start": 453032, "crunched": 0, "end": 466800, "filename": "/modules/hump/docs/_static/vector-perpendicular.png"}, {"audio": 0, "start": 466800, "crunched": 0, "end": 496707, "filename": "/modules/hump/docs/_static/vector-projectOn.png"}, {"audio": 0, "start": 496707, "crunched": 0, "end": 509389, "filename": "/modules/hump/docs/_static/vector-rotated.png"}, {"audio": 0, "start": 509389, "crunched": 0, "end": 511018, "filename": "/modules/hump/spec/timer_spec.lua"}, {"audio": 0, "start": 511018, "crunched": 0, "end": 517166, "filename": "/res/.DS_Store"}, {"audio": 0, "start": 517166, "crunched": 0, "end": 524658, "filename": "/res/background.png"}, {"audio": 0, "start": 524658, "crunched": 0, "end": 588114, "filename": "/res/background_blur.png"}, {"audio": 0, "start": 588114, "crunched": 0, "end": 588229, "filename": "/res/bee.png"}, {"audio": 0, "start": 588229, "crunched": 0, "end": 588351, "filename": "/res/bee_dead.png"}, {"audio": 0, "start": 588351, "crunched": 0, "end": 588470, "filename": "/res/bee_wings.png"}, {"audio": 0, "start": 588470, "crunched": 0, "end": 588674, "filename": "/res/cursor.png"}, {"audio": 0, "start": 588674, "crunched": 0, "end": 588889, "filename": "/res/dandelion_core.png"}, {"audio": 0, "start": 588889, "crunched": 0, "end": 590609, "filename": "/res/dandelion_puff.png"}, {"audio": 0, "start": 590609, "crunched": 0, "end": 590977, "filename": "/res/droplet.png"}, {"audio": 0, "start": 590977, "crunched": 0, "end": 591083, "filename": "/res/droplet_small.png"}, {"audio": 0, "start": 591083, "crunched": 0, "end": 600034, "filename": "/res/ending_death.png"}, {"audio": 0, "start": 600034, "crunched": 0, "end": 615585, "filename": "/res/ending_swarm.png"}, {"audio": 0, "start": 615585, "crunched": 0, "end": 616395, "filename": "/res/flower_petals.png"}, {"audio": 0, "start": 616395, "crunched": 0, "end": 616616, "filename": "/res/flower_pollen.png"}, {"audio": 0, "start": 616616, "crunched": 0, "end": 616843, "filename": "/res/flower_stamen.png"}, {"audio": 0, "start": 616843, "crunched": 0, "end": 617219, "filename": "/res/flower_stem.png"}, {"audio": 0, "start": 617219, "crunched": 0, "end": 617784, "filename": "/res/fly_body.png"}, {"audio": 0, "start": 617784, "crunched": 0, "end": 618032, "filename": "/res/fly_legs.png"}, {"audio": 0, "start": 618032, "crunched": 0, "end": 618439, "filename": "/res/fly_wings.png"}, {"audio": 0, "start": 618439, "crunched": 0, "end": 623222, "filename": "/res/foreground.png"}, {"audio": 0, "start": 623222, "crunched": 0, "end": 668894, "filename": "/res/foreground_blur.png"}, {"audio": 0, "start": 668894, "crunched": 0, "end": 670303, "filename": "/res/frog.png"}, {"audio": 0, "start": 670303, "crunched": 0, "end": 670407, "filename": "/res/frog_eye.png"}, {"audio": 0, "start": 670407, "crunched": 0, "end": 671012, "filename": "/res/frog_mouth.png"}, {"audio": 0, "start": 671012, "crunched": 0, "end": 671119, "filename": "/res/frog_tongue.png"}, {"audio": 0, "start": 671119, "crunched": 0, "end": 671382, "filename": "/res/frog_tongue_tip.png"}, {"audio": 0, "start": 671382, "crunched": 0, "end": 671642, "filename": "/res/grass_1.png"}, {"audio": 0, "start": 671642, "crunched": 0, "end": 671898, "filename": "/res/grass_2.png"}, {"audio": 0, "start": 671898, "crunched": 0, "end": 672110, "filename": "/res/hud_bee.png"}, {"audio": 0, "start": 672110, "crunched": 0, "end": 672329, "filename": "/res/hud_tree.png"}, {"audio": 0, "start": 672329, "crunched": 0, "end": 673065, "filename": "/res/raindrop_large.png"}, {"audio": 0, "start": 673065, "crunched": 0, "end": 673538, "filename": "/res/raindrop_medium.png"}, {"audio": 0, "start": 673538, "crunched": 0, "end": 673747, "filename": "/res/raindrop_particle.png"}, {"audio": 0, "start": 673747, "crunched": 0, "end": 673983, "filename": "/res/raindrop_small.png"}, {"audio": 0, "start": 673983, "crunched": 0, "end": 675274, "filename": "/res/raindrop_splash.png"}, {"audio": 0, "start": 675274, "crunched": 0, "end": 679205, "filename": "/res/title_logo.png"}, {"audio": 0, "start": 679205, "crunched": 0, "end": 681833, "filename": "/res/tree.png"}, {"audio": 0, "start": 681833, "crunched": 0, "end": 682241, "filename": "/res/tree_branch.png"}, {"audio": 0, "start": 682241, "crunched": 0, "end": 682927, "filename": "/res/tree_hive.png"}, {"audio": 0, "start": 682927, "crunched": 0, "end": 685672, "filename": "/res/yellow_puff.png"}, {"audio": 0, "start": 685672, "crunched": 0, "end": 735104, "filename": "/res/fonts/redalert.ttf"}, {"audio": 1, "start": 735104, "crunched": 0, "end": 1791050, "filename": "/res/sounds/bee_ambient.mp3"}, {"audio": 1, "start": 1791050, "crunched": 0, "end": 2533204, "filename": "/res/sounds/bee_calm.mp3"}, {"audio": 1, "start": 2533204, "crunched": 0, "end": 3606186, "filename": "/res/sounds/bee_dangerous.mp3"}, {"audio": 1, "start": 3606186, "crunched": 0, "end": 3634390, "filename": "/res/sounds/droplet.wav"}, {"audio": 1, "start": 3634390, "crunched": 0, "end": 3642686, "filename": "/res/sounds/fly.mp3"}, {"audio": 1, "start": 3642686, "crunched": 0, "end": 3653618, "filename": "/res/sounds/poof.mp3"}, {"audio": 1, "start": 3653618, "crunched": 0, "end": 3866249, "filename": "/res/sounds/rain.mp3"}, {"audio": 1, "start": 3866249, "crunched": 0, "end": 3918273, "filename": "/res/sounds/ribbit.wav"}, {"audio": 1, "start": 3918273, "crunched": 0, "end": 3989631, "filename": "/res/sounds/thunder.mp3"}, {"audio": 0, "start": 3989631, "crunched": 0, "end": 3995779, "filename": "/src/.DS_Store"}, {"audio": 0, "start": 3995779, "crunched": 0, "end": 3997229, "filename": "/src/animation.lua"}, {"audio": 0, "start": 3997229, "crunched": 0, "end": 3998742, "filename": "/src/camera.lua"}, {"audio": 0, "start": 3998742, "crunched": 0, "end": 4002874, "filename": "/src/chunkSpawner.lua"}, {"audio": 0, "start": 4002874, "crunched": 0, "end": 4003151, "filename": "/src/constants.lua"}, {"audio": 0, "start": 4003151, "crunched": 0, "end": 4006121, "filename": "/src/music.lua"}, {"audio": 0, "start": 4006121, "crunched": 0, "end": 4007175, "filename": "/src/objects.lua"}, {"audio": 0, "start": 4007175, "crunched": 0, "end": 4008290, "filename": "/src/rain.lua"}, {"audio": 0, "start": 4008290, "crunched": 0, "end": 4012284, "filename": "/src/objects/bee.lua"}, {"audio": 0, "start": 4012284, "crunched": 0, "end": 4014940, "filename": "/src/objects/dandelion.lua"}, {"audio": 0, "start": 4014940, "crunched": 0, "end": 4017061, "filename": "/src/objects/enemy.lua"}, {"audio": 0, "start": 4017061, "crunched": 0, "end": 4021997, "filename": "/src/objects/flower.lua"}, {"audio": 0, "start": 4021997, "crunched": 0, "end": 4023887, "filename": "/src/objects/fly.lua"}, {"audio": 0, "start": 4023887, "crunched": 0, "end": 4028672, "filename": "/src/objects/frog.lua"}, {"audio": 0, "start": 4028672, "crunched": 0, "end": 4029329, "filename": "/src/objects/object.lua"}, {"audio": 0, "start": 4029329, "crunched": 0, "end": 4033297, "filename": "/src/objects/player.lua"}, {"audio": 0, "start": 4033297, "crunched": 0, "end": 4035492, "filename": "/src/objects/raindrop.lua"}, {"audio": 0, "start": 4035492, "crunched": 0, "end": 4038603, "filename": "/src/objects/tree.lua"}, {"audio": 0, "start": 4038603, "crunched": 0, "end": 4041187, "filename": "/src/states/dead.lua"}, {"audio": 0, "start": 4041187, "crunched": 0, "end": 4043437, "filename": "/src/states/finale.lua"}, {"audio": 0, "start": 4043437, "crunched": 0, "end": 4050700, "filename": "/src/states/game.lua"}, {"audio": 0, "start": 4050700, "crunched": 0, "end": 4053267, "filename": "/src/states/intro.lua"}, {"audio": 0, "start": 4053267, "crunched": 0, "end": 4054768, "filename": "/src/states/transition.lua"}], "remote_package_size": 4054768, "package_uuid": "4a96a974-f637-4e01-be17-ca4a2abd8a30"});

})();
