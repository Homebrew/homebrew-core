class Tofrodos < Formula
  desc "Converts DOS <-> UNIX text files, alias tofromdos"
  homepage "https://github.com/ChristopherHeng/tofrodos"
  url "https://github.com/ChristopherHeng/tofrodos/archive/refs/tags/2.1.1.tar.gz"
  sha256 "77e6855917e5dd04ff445b6de3f8373531af15b2cb70e3b29058658f9d495c06"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb9bccec0b6facab6deb29e573a58688ca536fc626a495c8dbf14b1bf30aa625"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1d7e019ae05f7eedc3b6f7eeed1576d3eaed131344ff5341f347d4a7232ac42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45523cb29f07d2958725ffee8b52a482ef7cc38a8b733b458d4c23f1ea484950"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc8b42d53d4c3f5c94aee049393680c0521d4cc8d10e4f08fc036662b8193ab9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23e087b1626acd44299d5a4c05bfbf8330824898a59f5e3514db5a94f119eeb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9736424740fa62707a4cd5061f5bc14958fc8726c69a9cd6f7d8dcadd800090b"
  end

  def install
    mkdir_p [bin, man1]

    system "make", "-f", "makefile.gcc", "all"
    system "make", "-f", "makefile.gcc", "BINDIR=#{bin}", "MANDIR=#{man1}", "install"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      Example text
    EOS

    shell_output("#{bin}/todos -b #{testpath}/test.txt")
    shell_output("#{bin}/fromdos #{testpath}/test.txt")
    assert_equal (testpath/"test.txt").read, (testpath/"test.txt.bak").read
  end
end
