class Uhubctl < Formula
  desc "USB hub per-port power control"
  homepage "https://github.com/mvp/uhubctl"
  url "https://github.com/mvp/uhubctl/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "56ca15ddf96d39ab0bf8ee12d3daca13cea45af01bcd5a9732ffcc01664fdfa2"
  license "GPL-2.0-only"
  head "https://github.com/mvp/uhubctl.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3d264b405111b616523248b1de4a0998b9c73f0c670a00e20358dcaeeed033cc"
    sha256 cellar: :any,                 arm64_sequoia: "45506e121cd1c2bdf1077b0086f6dae8adcf1b24c48c32882d2c06eee848b87a"
    sha256 cellar: :any,                 arm64_sonoma:  "28e0b5ad40356523caf8b0e489af4f5a18cfcebafb21f323800068a3cb591f18"
    sha256 cellar: :any,                 arm64_ventura: "9aa4d8a4629679ba2346d33a5afa11d0b90a27c32f75de3eaf6c67859c35a2b5"
    sha256 cellar: :any,                 sonoma:        "c453944fda7c0a41845021a45cd07f42d870af48a5c893fa016a19f0cd3848f0"
    sha256 cellar: :any,                 ventura:       "d715191cd6f1574c69b4ca8d3d69cff12b500c26e925f07cf795aaaf0dc593bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d79e098adc1e2e6895c3659d146cbc1db5df67699b5e3092e5e85aee775d30c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07793f3832ebcec92c9f949974959c0593c777c20f760afbbfb000dd08f41b45"
  end

  depends_on "pkgconf" => :build
  depends_on "libusb"

  def install
    system "make"
    bin.install "uhubctl"
  end

  test do
    # test uhubctl -v:
    assert_match version.to_s, shell_output("#{bin}/uhubctl -v")

    # test for non-existent USB device:
    actual = shell_output("#{bin}/uhubctl -l 100-1.2.3.4.5 -a 0 -p 1 2>&1", 1)
    expected = /No compatible devices detected/
    assert_match expected, actual
  end
end
