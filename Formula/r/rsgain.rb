class Rsgain < Formula
  desc "ReplayGain 2.0 tagging utility"
  homepage "https://github.com/complexlogic/rsgain"
  url "https://github.com/complexlogic/rsgain/archive/refs/tags/v3.6.tar.gz"
  sha256 "26f7acd1ba0851929dc756c93b3b1a6d66d7f2f36b31f744c8181f14d7b5c8a7"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/complexlogic/rsgain.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "518dcf26b5b0c4c7600e6380f10c9219605ca8802eb2abd29a54510e88cad140"
    sha256 arm64_sonoma:  "8326d61a3223931540901f5173059fc2579310a0401b76ea81002fe0f06a6a5c"
    sha256 arm64_ventura: "7018f1dd0098583ec97d869024699a7f7e12d19515478d4f0b637be240f5adf8"
    sha256 sonoma:        "ba2789f8f8af6b801229e779dbc43a767ea4f0fad539586285c9e19f2f68f844"
    sha256 ventura:       "767220b19b5d1d987823284407efd91b84bf9de46c8c7e612bcc0f6272f4055c"
    sha256 arm64_linux:   "22cdbdadb44fabf91163b2893aa5332c32cf924399081592ccdaf581c9aefdd0"
    sha256 x86_64_linux:  "e471f4eedcc01d0af23e393ddd50f1795a3e220bf386465fe0398c9c537a18a2"
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
