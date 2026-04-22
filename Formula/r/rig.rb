class Rig < Formula
  desc "Provides fake name and address data"
  homepage "https://rig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/rig/rig/1.11/rig-1.11.tar.gz"
  sha256 "00bfc970d5c038c1e68bc356c6aa6f9a12995914b7d4fda69897622cb5b77ab8"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "dad2501e03504d0b5bbb423d2c9ef324aadf56f790f696c0a46ae04c6dab206f"
    sha256 arm64_sequoia: "2a9e7e9827a5a060ef485b046834ce2c9c8d592079c84c2385e5a68a533b367f"
    sha256 arm64_sonoma:  "bb02988845e379f76e2e403ff006185b67a490fcf399654a904adab3ea8a4c13"
    sha256 sonoma:        "23fd05abeb97e297ba941e14570cfcbe0a2c06a4b41b1413d1845fa44215123e"
    sha256 arm64_linux:   "55d7f3414a507b5c8d884ccb5c5d515bf9741d1190ebc88aba59f1c1ea57c45c"
    sha256 x86_64_linux:  "562461182b7a6e85a39b6128addfe1cf719486b27504f9b7e61d466cfec400bd"
  end

  conflicts_with "r-rig", because: "both install `rig` binary"

  # Fix build failure because of missing #include <cstring> on Linux.
  # Patch submitted to author by email.
  patch :DATA

  def install
    system "make", "PREFIX=#{prefix}"
    bin.install "rig"
    pkgshare.install Dir["data/*"]
  end

  test do
    system bin/"rig"
  end
end

__END__
diff --git a/rig.cc b/rig.cc
index 1f9a2e4..3a23ea8 100644
--- a/rig.cc
+++ b/rig.cc
@@ -21,6 +21,7 @@
 #include <fstream>
 #include <vector>
 #include <string>
+#include <cstring>
 #include <stdlib.h>
 #include <unistd.h>
 #include <time.h>
