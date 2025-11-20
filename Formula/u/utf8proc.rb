class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "dc146fd279eacbbf399d3f70932ce66f516aac2d13f8ec2d26a30f8ed70aa5b4"
  license all_of: ["MIT", "Unicode-DFS-2015"]
  head "https://github.com/JuliaStrings/utf8proc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c8ae2f5d0c749b8ade14d7da4e96a16e534e6213d67720e5ba90c3dc49144fa"
    sha256 cellar: :any,                 arm64_sequoia: "85342619eca43b1681d373f7568a00896059950352d82269d55d3096a331c90b"
    sha256 cellar: :any,                 arm64_sonoma:  "796f12b03324647262ebf32ac7ca8e97d01cb5f83dea30e36dd1cac949e261d4"
    sha256 cellar: :any,                 sonoma:        "8fbbfe7a92786fc3ad3a72d14e1ea74480b86d7966b292cdc3f0e5246f0b7bbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5f0740e6eef18cdb4a3b886bfc9f8a0178c7722ca4cfcab1bfb7e1d6f497689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4cb69b355bcfea3db4a960ebb903d8cb248677fa95dad4e5e28bf47b4cea345"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <string.h>
      #include <utf8proc.h>

      int main() {
        const char *version = utf8proc_version();
        return strnlen(version, sizeof("1.3.1-dev")) > 0 ? 0 : -1;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lutf8proc", "-o", "test"
    system "./test"
  end
end
