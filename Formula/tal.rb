class Tal < Formula
  desc "Align line endings if they match"
  # The canonical url currently returns HTTP/1.1 500 Internal Server Error.
  homepage "https://web.archive.org/web/20160406172703/https://thomasjensen.com/software/tal/"
  url "https://www.mirrorservice.org/sites/download.salixos.org/x86_64/extra-14.2/source/misc/tal/tal-1.9.tar.gz"
  mirror "https://web.archive.org/web/20160406172703/https://thomasjensen.com/software/tal/tal-1.9.tar.gz"
  sha256 "5d450cee7162c6939811bca945eb475e771efe5bd6a08b520661d91a6165bb4c"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94237b7f329c30c17aed19d82bb18a790abf2abcbfc404a57ef9e237db4a0735"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ca62e367e9b35b079d0419bc02c4baec570154a089337f4ffce87441e9ba7af"
    sha256 cellar: :any_skip_relocation, monterey:       "b869e27ee13cb3e2ec83b0bb24a3dfc17b753ae94afa8e11d5e75943e8f1c132"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff2e907039f88888af6724c384e32b3191fd39097266bbdcf415faa3b9cc927f"
    sha256 cellar: :any_skip_relocation, catalina:       "1d2978734ee3f0c63efdd0acdff401014954c34ed709ed397348dc1f3f973b88"
    sha256 cellar: :any_skip_relocation, mojave:         "3e9ac201bb27300afd327dd1a24c093e602376c4a4e36af27f7d1047ffae9b5d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "852023d9d33d893ca0852f36d795b044212e69911e2380cc4f0d22f99e22c1c2"
    sha256 cellar: :any_skip_relocation, sierra:         "9c2c4e5f9d6922f9a9d434485dea4ddf321744728c83adcda822c3c314f6a86e"
    sha256 cellar: :any_skip_relocation, el_capitan:     "bbdef6b2c92650352b7199cc2a9e3bc4698bf2a14fce46397eebcee72c1de419"
    sha256 cellar: :any_skip_relocation, yosemite:       "e6b6f315bc14f5e001893371d18fb0ba88bea4c4d76dd657820eecf509103f9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "568fa7d6db8a642d71501bd804351e281c512fa82f3c2757bc870e7e8d871ecd"
  end

  def install
    system "make", "linux"
    bin.install "tal"
    man1.install "tal.1"
  end

  test do
    system "#{bin}/tal", "/etc/passwd"
  end
end
