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
    rebuild 5
    sha256                               arm64_tahoe:   "d10703185cc1b8b3312bdbc0621131238980f07481bab599dcc498a06e1c1106"
    sha256                               arm64_sequoia: "a57f1047d84abdf6272e01276e21ca325a0ca8b5aa716fba5fd91f9b4bedcf44"
    sha256                               arm64_sonoma:  "635b13fc20043aaee3de8be3c111caef4eb8213643ea04257b6ca7834ccddd49"
    sha256 cellar: :any,                 sonoma:        "c2b21d678a8d0d0f785d8257a32c7d48a7992adef5b6a7c14e6cd4e34d79cf3b"
    sha256                               arm64_linux:   "b92128272614278c0799f954abebd5cb9404ded017babda7f8a5767ffb60e8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c37220d056fd15397e731350bf2078625e70b50baf9033db994aa2a18e5f9f62"
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
      -DPYTHON3_EXECUTABLE=#{which(python3)}
      -DSOAPY_SDR_ROOT=#{HOMEBREW_PREFIX}
    ]
    args << "-DSOAPY_SDR_EXTVER=release" if build.stable?

    site_packages = prefix/Language::Python.site_packages(python3)
    args << "-DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: site_packages)}" if OS.mac?

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
