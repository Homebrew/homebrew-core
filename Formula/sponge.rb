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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "30487b971b483205d6919798d5337513b17be29ae44b926a38f48c47cf6f3854"
    sha256 cellar: :any_skip_relocation, big_sur:       "5dbc5081ef6e8c4989be271a51888d61ddd264f5729c6e42a4b6e2ef1c921aa3"
    sha256 cellar: :any_skip_relocation, catalina:      "0d95bfe87988a49776eda4357bc5167478dcec5778df40948a1aa8509adb86fb"
    sha256 cellar: :any_skip_relocation, mojave:        "a7237e32f0c4afd058582c84b391a8acb44e880272cfbfbc122c5d45e690f961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fce3d65ee17083d87c7bde42e7ca218087ce57d10bce2daa85ff0f8498964592"
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
