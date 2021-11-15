class Sponge < Formula
  desc "Soak up standard input and write to a file"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://git.joeyh.name/index.cgi/moreutils.git/snapshot/moreutils-0.66.tar.gz"
  sha256 "dc079e018aaff22446cf36eccb298627bb0222ec6dc23a173860c9e1f16e214d"
  license "GPL-2.0-only"

  livecheck do
    url "https://git.joeyh.name/index.cgi/moreutils.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29cd7099471ec99361f0960dd460d428ed68a152fe360265e465773a55840d88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4cc701ce73bfceca71d73a7736a588772f4f3987f577763e5abb9c462d25a78f"
    sha256 cellar: :any_skip_relocation, monterey:       "59439f71fc93d7c0b1e943dcd78a11b7a9eba39da4befa0015a10e066dd0dc75"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e1d78aae23a4a4468c44eaa1941ebda24cfeb739044e1b47e4b28d1e1471ca6"
    sha256 cellar: :any_skip_relocation, catalina:       "81ba802eac1d5423220408709176ae92641b156b661b1f6821c91a18d7f20bed"
    sha256 cellar: :any_skip_relocation, mojave:         "f5580c82edb4d175d1285ff3320606785820b65e7c04e912a15b6405d34fc303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f179a9c9f9215497e21595315fb13dd834caab7cd750ef77ec2c2e9626ff37e"
  end

  conflicts_with "moreutils", because: "both install a `sponge` executable"

  def install
    system "make", "sponge"
    bin.install "sponge"
  end

  test do
    file = testpath/"sponge-test.txt"
    file.write("c\nb\na\n")
    system "sort #{file} | #{bin/"sponge"} #{file}"
    assert_equal "a\nb\nc\n", File.read(file)
  end
end
