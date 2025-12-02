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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 4
    sha256                               arm64_tahoe:   "52ad613af98da0b017164de38b0029ec486d8c3b602735ac13dee37bd06b9ef1"
    sha256                               arm64_sequoia: "b370df36657b7a9948cfe87614c270397370abaa1ae524aed812378c45a01a2c"
    sha256                               arm64_sonoma:  "813a78fda8de094ad4fc55f3639ccb2613093c3417d63f1365fbbbde2143f878"
    sha256 cellar: :any,                 sonoma:        "be69465ae0ab16f994a8fa2333a6af39dda156f57502dbdc3e1f0f4556c2f975"
    sha256                               arm64_linux:   "fd95f81a9f8ae0308000a40b1a7bf0316b86aebeec1cf94283ccefbb0a48ec7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06d821fe8e03e9746d93d7667bbb9655d3c05ee8fa1f7764447b0c8ce36592fd"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "python@3.14"

  def python3
    "python3.14"
  end

  def install
    args = %W[
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DSOAPY_SDR_ROOT=#{HOMEBREW_PREFIX}
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DSOAPY_SDR_EXTVER=release" if build.stable?

    # Workaround until next release to avoid backporting multiple commits
    if build.stable?
      args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
      odie "Remove `-DCMAKE_POLICY_VERSION_MINIMUM=3.5`" if version > "0.8.1"
    end

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
