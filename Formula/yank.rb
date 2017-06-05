class Yank < Formula
  desc "Copy terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v0.8.3.tar.gz"
  sha256 "39a3ccf6d2b0cb803b6d133c477030236660ef5349c7f0556b5a6644cc7588b0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2213f36ca308b83ab401b16892af5e06b2d6730fac83677231c2a0c05bb6bd5" => :sierra
    sha256 "d6ee61b46c20470fd9f89643697d1fbe83ac2b0f009aa97203b1cdeda9d9eb19" => :el_capitan
    sha256 "6868dbd03b5260ca4e2fb87bad8821475893ccf9f41a2fcd4e1ec9029eefb755" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "YANKCMD=pbcopy"
  end

  test do
    (testpath/"test.exp").write <<-EOS.undent
      spawn sh
      set timeout 1
      send "echo key=value | #{bin}/yank -d = | cat"
      send "\r"
      send "\016"
      send "\r"
      expect {
            "value" { send "exit\r"; exit 0 }
            timeout { send "exit\r"; exit 1 }
      }
    EOS
    system "expect", "-f", "test.exp"
  end
end
