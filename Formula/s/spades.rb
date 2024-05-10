class Spades < Formula
  include Language::Python::Shebang

  desc "De novo genome sequence assembly"
  homepage "https://github.com/ablab/spades"
  license "GPL-2.0-only"

  # TODO: Remove stable dependencies and fails_with in the next release.
  # Instead, the head dependencies should be used everywhere.
  stable do
    url "https://github.com/ablab/spades/releases/download/v3.15.5/SPAdes-3.15.5.tar.gz"
    sha256 "155c3640d571f2e7b19a05031d1fd0d19bd82df785d38870fb93bd241b12bbfa"

    on_macos do
      depends_on "gcc"
    end

    fails_with :clang do
      cause "fails to link with recent `libomp`"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 sonoma:       "596f3c88c276179428ce87c7801b6e41483bdaca32f97e809d1e74c6ab656104"
    sha256 cellar: :any,                 ventura:      "f03d022acc5928a400a57d56815a314cdbe2b72c5600eb952096e57fd4abd85a"
    sha256 cellar: :any,                 monterey:     "c4da4be23d91abf193367765d6bee9cbd758add046aee900caec845d1bed243b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c284a1b00ebca8794f3f4396f481c09228aedc0ea4b6d2ad364a4efb29115a7e"
  end

  head do
    url "https://github.com/ablab/spades.git", branch: "next"

    on_macos do
      depends_on "libomp"
    end
  end

  depends_on "cmake" => :build
  depends_on "python@3.12"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "jemalloc"
    depends_on "readline"
  end

  # Drop distutils, upstream commit doesn't apply cleanly
  # https://github.com/ablab/spades/commit/3ba9e5254b7d1ccb0c55d42b7d38b8be6f7d0648
  patch :DATA

  def install
    system "cmake", "-S", "src", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end

__END__
diff --git a/src/spades_pipeline/support.py b/src/spades_pipeline/support.py
index c66faf0..ac1af7d 100644
--- a/src/spades_pipeline/support.py
+++ b/src/spades_pipeline/support.py
@@ -20,7 +20,6 @@ import sys
 import tempfile
 import traceback
 from platform import uname
-from distutils.version import LooseVersion
 from os.path import abspath, expanduser, join

 import options_storage
@@ -95,30 +94,16 @@ def sys_error(cmd, log, exit_code):


 def check_python_version():
-    def __next_version(version):
-        components = version.split('.')
-        for i in reversed(range(len(components))):
-            if components[i].isdigit():
-                components[i] = str(int(components[i]) + 1)
-                break
-        return '.'.join(components)
-
-    current_version = sys.version.split()[0]
-    supported_versions_msg = []
-    for supported_versions in options_storage.SUPPORTED_PYTHON_VERSIONS:
-        major = supported_versions[0]
-        if '-' in supported_versions:  # range
-            min_inc, max_inc = supported_versions.split('-')
-        elif supported_versions.endswith('+'):  # half open range
-            min_inc, max_inc = supported_versions[:-1], major
-        else:  # exact version
-            min_inc = max_inc = supported_versions
-        max_exc = __next_version(max_inc)
-        supported_versions_msg.append("Python%s: %s" % (major, supported_versions.replace('+', " and higher")))
-        if LooseVersion(min_inc) <= LooseVersion(current_version) < LooseVersion(max_exc):
-            return True
-    error("python version %s is not supported!\n"
-          "Supported versions are %s" % (current_version, ", ".join(supported_versions_msg)))
+    MINIMAL_PYTHON_VERSION = (3, 2)
+
+    if sys.version_info < MINIMAL_PYTHON_VERSION:
+        error(
+            "\nPython version %s is not supported!\n"
+            "Minimal supported version is %s"
+            % (sys.version.split()[0], ".".join(list(map(str, MINIMAL_PYTHON_VERSION))))
+        )
+        return False
+    return True


 def get_spades_binaries_info_message():
