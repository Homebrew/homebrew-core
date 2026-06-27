class Uggconv < Formula
  desc "Universal Game Genie code converter"
  homepage "https://web.archive.org/web/20230505074213/https://wyrmcorp.com/software/uggconv/index.shtml"
  url "https://web.archive.org/web/20230505074320/https://wyrmcorp.com/software/uggconv/uggconv-1.0.tar.gz"
  sha256 "9a215429bc692b38d88d11f38ec40f43713576193558cd8ca6c239541b1dd7b8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3802603d8a8f1cadf23ebd88778fdeff1a797cd6241cb0f7460e6784bba01971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b7da823890abb6aa5b02742c2b75d104883781b2c58bc3ae45469e936fadb1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad9e49d325916e5ae774fdb74c4ab2c9f8624316a920dfe8a1394d2a395ff049"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27654b49d8d698a39c1e7592fad41eaa5c81a8151196b7eb054c0e711bee4a36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "002cd504e9385234ab9b1b4595709ffccb2fda5d49c377add9c27eb422c04ed3"
    sha256 cellar: :any_skip_relocation, sonoma:         "b47543cb9b25c23ea21d206a3fc46630a736e29a0e673251cc7eb6c1ef77085e"
    sha256 cellar: :any_skip_relocation, ventura:        "2118cac3d4f75602660b9c8249ad80889313144e1705b9be04dccfd4e8ef5257"
    sha256 cellar: :any_skip_relocation, monterey:       "ad5e3778249cab414b73491a205ffc0c45817d0061dcf59d561315e544eeca4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "820cca76f8c5618ba401a343644cffae2ece5526e0295dc29d0dd0f5f524789a"
    sha256 cellar: :any_skip_relocation, catalina:       "c1fc237ad27120a1804b37d765a47833d67bcd38cfa67be07aed808739021146"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "288f3d97f53ba57c9fbe6901a0e4739ff76c2f1965728dd10e383112365ab7c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70d91fd685adcb8943530056934bc1e8f0ed0c5502a9205c6b1c8fa982fdec53"
  end

  # upstream is gone
  deprecate! date: "2024-09-11", because: :repo_removed
  disable! date: "2025-09-11", because: :repo_removed

  # Add missing `#include`.
  patch :DATA

  def install
    system "make"
    bin.install "uggconv"
    man1.install "uggconv.1"
  end

  test do
    assert_equal "7E00CE:03    = D7DA-FE86\n",
      shell_output("#{bin}/uggconv -s 7E00CE:03")
  end
end

__END__
--- a/uggconv.c
+++ b/uggconv.c
@@ -47,6 +47,7 @@
  */
 
 #include <stdio.h>
+#include <stdlib.h>
 #include <string.h>
 #include <ctype.h>
 
