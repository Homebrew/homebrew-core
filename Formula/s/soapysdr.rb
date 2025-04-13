class Soapysdr < Formula
  desc "Vendor and platform neutral SDR support library"
  homepage "https://github.com/pothosware/SoapySDR/wiki"
  license "BSL-1.0"
  revision 1
  head "https://github.com/pothosware/SoapySDR.git", branch: "master"

  stable do
    url "https://github.com/pothosware/SoapySDR/archive/refs/tags/soapy-sdr-0.8.1.tar.gz"
    sha256 "a508083875ed75d1090c24f88abef9895ad65f0f1b54e96d74094478f0c400e6"

    # Replace distutils for python 3.12+
    # https://github.com/pothosware/SoapySDR/commit/1ee5670803f89b21d84a6a84acbb578da051c119
    patch :DATA
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sequoia: "2cd1b0106c59df55ee3022f0e426718979343f8c0791a1cbf189a0230b582967"
    sha256 cellar: :any,                 arm64_sonoma:  "037c6ec56ece7b022d890f8c42f9e8b7e012ec9a641901d4d73a961a8f7f069d"
    sha256 cellar: :any,                 arm64_ventura: "d091d29209ae4319ddb8db5f2bc8c3f828953db36b619f2288df08c6cb2f2db1"
    sha256 cellar: :any,                 sonoma:        "e90833db385d8e3ce0c8eb4f138834d1da1db6879ca46be2f5f52a4f68957e44"
    sha256 cellar: :any,                 ventura:       "dbbc7e560136986fb5604d2c752890d5ee299725768fa61dc5ddd2bfd2e73be0"
    sha256                               arm64_linux:   "20de753561fae444f356d230eff4d1d67dee481e6db1bed339dd419d710eaf64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1227202d6306ddbc0d33b3f94904cc51b6ebfd61802fd411fb51fdd306e2f4a"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  def install
    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DSOAPY_SDR_ROOT=#{HOMEBREW_PREFIX}
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DSOAPY_SDR_EXTVER=release" unless build.head?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Loading modules... done", shell_output("#{bin}/SoapySDRUtil --check=null")
    system python3, "-c", "import SoapySDR"
  end
end

__END__
diff --git a/python/get_python_lib.py b/python/get_python_lib.py
index 0c71652..307ab51 100644
--- a/python/get_python_lib.py
+++ b/python/get_python_lib.py
@@ -1,19 +1,35 @@
 import os
+import pathlib
 import sys
-import site
-from distutils.sysconfig import get_python_lib
+import sysconfig

-if __name__ == '__main__':
-    prefix = sys.argv[1]
+if __name__ == "__main__":
+    prefix = pathlib.Path(sys.argv[1]).resolve()

-    #ask distutils where to install the python module
-    install_dir = get_python_lib(plat_specific=True, prefix=prefix)
+    # default install dir for the running Python interpreter
+    default_install_dir = pathlib.Path(sysconfig.get_path("platlib")).resolve()

-    #use sites when the prefix is already recognized
+    # if default falls under the desired prefix, we're done
     try:
-        paths = [p for p in site.getsitepackages() if p.startswith(prefix)]
-        if len(paths) == 1: install_dir = paths[0]
-    except AttributeError: pass
+        relative_install_dir = default_install_dir.relative_to(prefix)
+    except ValueError:
+        # get install dir for the specified prefix
+        # can't use the default scheme because distributions modify it
+        # newer Python versions have 'venv' scheme, use for all OSs.
+        if "venv" in sysconfig.get_scheme_names():
+            scheme = "venv"
+        elif os.name == "nt":
+            scheme = "nt"
+        else:
+            scheme = "posix_prefix"
+        prefix_install_dir = pathlib.Path(
+            sysconfig.get_path(
+                "platlib",
+                scheme=scheme,
+                vars={"base": prefix, "platbase": prefix},
+            )
+        ).resolve()
+        relative_install_dir = prefix_install_dir.relative_to(prefix)

-    #strip the prefix to return a relative path
-    print(os.path.relpath(install_dir, prefix))
+    # want a relative path for use in the build system
+    print(relative_install_dir)
