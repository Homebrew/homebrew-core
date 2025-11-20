class Rig < Formula
  desc "Provides fake name and address data"
  homepage "https://rig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/rig/rig/1.11/rig-1.11.tar.gz"
  sha256 "00bfc970d5c038c1e68bc356c6aa6f9a12995914b7d4fda69897622cb5b77ab8"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:    "5ac9d502e26fd90e8e7c695fd294e68e40feed89d8c3cf887ea0435c8f1fdb71"
    sha256                               arm64_sequoia:  "794a9e6df14ced7ebcdfdd890a1a51145882325ff6f196b0775f4503289ef38a"
    sha256                               arm64_sonoma:   "c49772908fab4d132435015e225760d30f00d742f5e09123c71cdf90a453d3ea"
    sha256                               arm64_ventura:  "1ffffb584e30f49d7b8c4b5dcc99141fff24697dc0512a6cfd8deba04720ef54"
    sha256                               arm64_monterey: "beffb2a7922b42831deb088af7d1f9ae0aefd703f676a1bafffa420ea96bf23c"
    sha256                               arm64_big_sur:  "b9736b9b35547ab9af2afc1e84698f5001e7f0ba9208ee171a58f554d9780c25"
    sha256                               sonoma:         "643e207aeaaeefde3364f9d95eb743afd98973cce9220c374bb4b23cbc0740dc"
    sha256                               ventura:        "605e1c4428ce942389573258015a36bc3a20c8e5dc7464ff3fd57240a816f72f"
    sha256 cellar: :any_skip_relocation, monterey:       "5b3a4522d3f584f5239b2e993517d20f5d37fcfa474c8ba0fad8be7aa91372d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e763b581f6a9410df5cca2384f0f9108c06a1c2e90ad3ebfccf7bf2297b7b641"
    sha256 cellar: :any_skip_relocation, catalina:       "e75fa428f9833207c6fa53e005e32c8d3af48206e08ded637d9633c2af1e0643"
    sha256                               arm64_linux:    "59facd287d0415f45ad5b63fcd7fceb389fa27f955ae79570bc03af560c0bccf"
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
