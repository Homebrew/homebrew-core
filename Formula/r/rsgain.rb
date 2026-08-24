class Rsgain < Formula
  desc "ReplayGain 2.0 tagging utility"
  homepage "https://github.com/complexlogic/rsgain"
  url "https://github.com/complexlogic/rsgain/archive/refs/tags/v3.7.tar.gz"
  sha256 "ef383af1adbc01a6e858b45b67b632168ef7c1ee8c2f8267630cbd0f9bf8498e"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/complexlogic/rsgain.git", branch: "master"

  bottle do
    sha256               arm64_tahoe:   "fe6261b47e3a431ff916b511ec81f803a230f3d620e1556016af4a1da6de01c6"
    sha256               arm64_sequoia: "3635fb6b957ec702eee3e7e8c579420f19f8efdd8d5116fbe543b23d596808e4"
    sha256               arm64_sonoma:  "50e83fa697d8bac616dd21a279cfac5e6c7af49b5808fa9486669a73d32b6b67"
    sha256               sonoma:        "8869992b1c9477e4483d04ecb2c4188aa6c6c076fd5b17134577a450d6f4f131"
    sha256               arm64_linux:   "5e0d843c9b091462abb139cb7c3387244d8b3b33ee209d9ed39f03cf83773619"
    sha256 cellar: :any, x86_64_linux:  "d1ae2279bd9319ce1859df38172a7b25c9420a787aa6be68adf535c364999e17"
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
