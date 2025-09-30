class Rsgain < Formula
  desc "ReplayGain 2.0 tagging utility"
  homepage "https://github.com/complexlogic/rsgain"
  url "https://github.com/complexlogic/rsgain/archive/refs/tags/v3.6.tar.gz"
  sha256 "26f7acd1ba0851929dc756c93b3b1a6d66d7f2f36b31f744c8181f14d7b5c8a7"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/complexlogic/rsgain.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "af27d5a12c51408d89c3a503d11133ab34e84b94b07697f24226bd9f31e8327e"
    sha256 arm64_sequoia: "55489cd56bf55d3a29a6f77c03457067f277e0c9558d26d77f893edee99f3b40"
    sha256 arm64_sonoma:  "c4e28904289af858e3e94c4e35afb4ef50bb346c2653e1d8242458bf59a88bb7"
    sha256 arm64_ventura: "55edda0ef4956e33ebfe076646857955637e20acb263f64c856d6825d68f5107"
    sha256 sonoma:        "201e665906b0b6dc438c501c0563bf36420d0f1d3ee54448171e47151d47912a"
    sha256 ventura:       "daa35290fc3a0df807859616ab512541f3586553f2e2142f0c10ce374c29f284"
    sha256 arm64_linux:   "bf6720904216103d47b92220321417062d94dd51d786deb73441698aaba9ce08"
    sha256 x86_64_linux:  "35c290b9f586cf607396625322e6ed6415b07472e98f2135d191763b79acf95b"
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
