class Rig < Formula
  desc "Provides fake name and address data"
  homepage "https://rig.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/rig/rig/1.11/rig-1.11.tar.gz"
  sha256 "00bfc970d5c038c1e68bc356c6aa6f9a12995914b7d4fda69897622cb5b77ab8"
  license "GPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "1ffffb584e30f49d7b8c4b5dcc99141fff24697dc0512a6cfd8deba04720ef54"
    sha256                               arm64_monterey: "beffb2a7922b42831deb088af7d1f9ae0aefd703f676a1bafffa420ea96bf23c"
    sha256                               arm64_big_sur:  "b9736b9b35547ab9af2afc1e84698f5001e7f0ba9208ee171a58f554d9780c25"
    sha256                               ventura:        "605e1c4428ce942389573258015a36bc3a20c8e5dc7464ff3fd57240a816f72f"
    sha256 cellar: :any_skip_relocation, monterey:       "5b3a4522d3f584f5239b2e993517d20f5d37fcfa474c8ba0fad8be7aa91372d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e763b581f6a9410df5cca2384f0f9108c06a1c2e90ad3ebfccf7bf2297b7b641"
    sha256 cellar: :any_skip_relocation, catalina:       "e75fa428f9833207c6fa53e005e32c8d3af48206e08ded637d9633c2af1e0643"
    sha256 cellar: :any_skip_relocation, mojave:         "8f311170956140550544c6a9e9b31068b61c5db52fefa2c92dd0ad565c0fc145"
    sha256 cellar: :any_skip_relocation, high_sierra:    "770e85dcfaeec7cf4e4799572b102bf436afc9f3d28eb828ef838b5a1e1a8152"
    sha256 cellar: :any_skip_relocation, sierra:         "fcc18ba335af01c00a5a7e7e41f6431192393d13eb374513ebe9b0b2a75ab0a0"
    sha256 cellar: :any_skip_relocation, el_capitan:     "d82301a0557554e57252ea0d020f32e1d13485077c54f4d68cce01ee9d1b34a3"
    sha256                               x86_64_linux:   "ea660b88d2d27477728bd628b496e6a6588c7dff8d4a46051e2b9fd0504e726b"
  end

  # Fix build failure because of missing #include <cstring> on Linux.
  # Patch submitted to author by email.
  patch :DATA

  def install
    system "make", "PREFIX=#{prefix}"
    bin.install "rig"
    pkgshare.install Dir["data/*"]
  end

  test do
    system "#{bin}/rig"
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
