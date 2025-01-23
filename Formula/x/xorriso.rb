class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "https://ftp.gnu.org/gnu/xorriso/xorriso-1.5.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/xorriso/xorriso-1.5.6.tar.gz"
  sha256 "d4b6b66bd04c49c6b358ee66475d806d6f6d7486e801106a47d331df1f2f8feb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9b8deb74524ee426ccfed55983d41f621de69ba1ffea7c574496b1bec72ef3ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4231bedc678f7cbb7151e5dd846ade6123811b472b7a378164b29d0edaaf8680"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e64ea078ab6659f5892db71cf6d2c72825cbefb80956ee88a8aaf5d0080594d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c7004800a9d909e5cbe3373dbb2d8fb71a943d022901f8a5b950c34c52215b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6a4f6c99d783a4c6c7b32438aae079f7d769b34ad831310868309fe275ff585"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9020ad45bcbf572393a1a95377c38fb8aaf861aaa09510d379fdd19e0f9a598"
    sha256 cellar: :any_skip_relocation, ventura:        "3865faab160986fdaa7e94f37056a15a1b790a32501118e4d6ab91abeb9543ce"
    sha256 cellar: :any_skip_relocation, monterey:       "b0d7600730ba18eab8cdc658ddeb80f849906fbd505694a7603e57650568b392"
    sha256 cellar: :any_skip_relocation, big_sur:        "b69459a4b5cbf28b29730e7b79ee89f1fd916d2c7f05c4de83826296c576a79f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af398fe111c552f7c70837d0179cd5f42784a79444fb9dc913c4fdf4b0eb8da6"
  end

  uses_from_macos "zlib"

  # Submit the patch into the upstream, see:
  # https://lists.gnu.org/archive/html/bug-xorriso/2023-06/msg00000.html
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    # `make install` has to be deparallelized due to the following error:
    #   mkdir: /usr/local/Cellar/xorriso/1.4.2/bin: File exists
    #   make[1]: *** [install-binPROGRAMS] Error 1
    # Reported 14 Jun 2016: https://lists.gnu.org/archive/html/bug-xorriso/2016-06/msg00003.html
    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match "List of xorriso extra features", shell_output("#{bin}/xorriso -list_extras")
    assert_match version.to_s, shell_output("#{bin}/xorriso -version")
  end
end

__END__
diff --git a/libisofs/rockridge.h b/libisofs/rockridge.h
index 5649eb7..01c4224 100644
--- a/libisofs/rockridge.h
+++ b/libisofs/rockridge.h
@@ -41,6 +41,8 @@

 #include "ecma119.h"

+/* For ssize_t */
+#include <unistd.h>

 #define SUSP_SIG(entry, a, b) ((entry->sig[0] == a) && (entry->sig[1] == b))
