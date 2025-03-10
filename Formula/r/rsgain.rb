class Rsgain < Formula
  desc "ReplayGain 2.0 tagging utility"
  homepage "https://github.com/complexlogic/rsgain"
  url "https://github.com/complexlogic/rsgain/archive/refs/tags/v3.6.tar.gz"
  sha256 "26f7acd1ba0851929dc756c93b3b1a6d66d7f2f36b31f744c8181f14d7b5c8a7"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/complexlogic/rsgain.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "b2433f35b7da266a70a375f995f1a2652856027b3abe1358dc8c0717acabf4e8"
    sha256 arm64_sonoma:  "22a1683c97acbea8180d40997712b2e8d2ebdef076f0ce07646ff353aa8f95a4"
    sha256 arm64_ventura: "0c8d037388a23c8fa67502e653531c64168cfadd7664a4222441dba05cf7a1b3"
    sha256 sonoma:        "0fbc514f29561beba99c42a9b9bba3e8a0e6d26b551308537807cbb264ac602d"
    sha256 ventura:       "91448967db7a47ddc8677884fa30517deec419b627d595ae9704f301c1447238"
    sha256 x86_64_linux:  "ff39e7ba90604a02efdb5352c656c67ec5d0b1a3b8cc9871e4a06bad090dcd14"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "fmt"
  depends_on "inih"
  depends_on "libebur128"
  depends_on "taglib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rsgain -v")

    assert_match "No files were scanned",
      shell_output("#{bin}/rsgain easy -S #{testpath}")
  end
end
