class Ranger < Formula
  include Language::Python::Virtualenv

  desc "File browser"
  homepage "https://ranger.github.io"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/ranger/ranger.git", branch: "master"

  stable do
    url "https://ranger.github.io/ranger-1.9.3.tar.gz"
    sha256 "ce088a04c91c25263a9675dc5c43514b7ec1b38c8ea43d9a9d00923ff6cdd251"

    # Drop `imghdr` for python 3.13
    # Backport of https://github.com/ranger/ranger/commit/9c0d3ba3495bac80142fad518e29b9061be94cc6
    patch :DATA
  end

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29f94668e81c45db4b87f46d183450c306196f58315d34c948090d87552d81a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29f94668e81c45db4b87f46d183450c306196f58315d34c948090d87552d81a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29f94668e81c45db4b87f46d183450c306196f58315d34c948090d87552d81a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4a0c957609a0dbc3c20f6bb0e420d1166bb65de6c205acca14ee85c880b68da"
    sha256 cellar: :any_skip_relocation, ventura:       "c4a0c957609a0dbc3c20f6bb0e420d1166bb65de6c205acca14ee85c880b68da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29f94668e81c45db4b87f46d183450c306196f58315d34c948090d87552d81a0"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ranger --version")

    code = "print('Hello World!')\n"
    (testpath/"test.py").write code
    assert_equal code, shell_output("#{bin}/rifle -w cat test.py")

    ENV.prepend_path "PATH", Formula["python@3.13"].opt_libexec/"bin"
    assert_equal "Hello World!\n", shell_output("#{bin}/rifle -p 2 test.py")
  end
end

__END__
diff --git a/ranger/ext/img_display.py b/ranger/ext/img_display.py
index ffaa4c0..a7e027e 100644
--- a/ranger/ext/img_display.py
+++ b/ranger/ext/img_display.py
@@ -15,7 +15,6 @@ import base64
 import curses
 import errno
 import fcntl
-import imghdr
 import os
 import struct
 import sys
@@ -341,12 +340,28 @@ class ITerm2ImageDisplayer(ImageDisplayer, FileManagerAware):
         with open(path, 'rb') as fobj:
             return base64.b64encode(fobj.read()).decode('utf-8')
 
+    @staticmethod
+    def imghdr_what(path):
+        """Replacement for the deprecated imghdr module"""
+        with open(path, "rb") as img_file:
+            header = img_file.read(32)
+            if header[6:10] in (b'JFIF', b'Exif'):
+                return 'jpeg'
+            elif header[:4] == b'\xff\xd8\xff\xdb':
+                return 'jpeg'
+            elif header.startswith(b'\211PNG\r\n\032\n'):
+                return 'png'
+            if header[:6] in (b'GIF87a', b'GIF89a'):
+                return 'gif'
+            else:
+                return None
+
     @staticmethod
     def _get_image_dimensions(path):
         """Determine image size using imghdr"""
         file_handle = open(path, 'rb')
         file_header = file_handle.read(24)
-        image_type = imghdr.what(path)
+        image_type = ITerm2ImageDisplayer.imghdr_what(path)
         if len(file_header) != 24:
             file_handle.close()
             return 0, 0
