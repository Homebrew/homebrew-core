class Tofrodos < Formula
  desc "Converts DOS <-> UNIX text files, alias tofromdos"
  homepage "https://github.com/ChristopherHeng/tofrodos"
  url "https://github.com/ChristopherHeng/tofrodos/archive/refs/tags/2.0.0.tar.gz"
  sha256 "9bac37ec72323fa0a98218e457c31d93c8fad5ba2e4f953e5c82bdcbc0aafaab"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bcf5f828ffe0cc532e0f8ed676dafea2ff7d9bec8713a4e9e08b7a154b7105c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1552fdcdff9a2cd5a3be3fd18f16c1fef4fe940fadef699ca3c502803932fc0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49a86b801c4c6211ca32b293088f4eeec9825d1f53bf366d1770e4330a15c79a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6300145de1846a449a733e36dce032ce5ef7b6273af7db40cbcc0757255d4891"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbc4d0b83975280eae92296808c8c08c2a6c3429efc766bb818fa6442629598f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52c5ef8d1778eeb76255a394c98ecd749707c4da9085f77f3daec810eac16910"
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
