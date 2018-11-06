class Yank < Formula
  desc "Copy terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v1.1.0.tar.gz"
  sha256 "7135e8faac75f28e83b8098bcc7a5c36fc430e7c4e17729e785392ad365dfd7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "80cb484aee8017a93216c8897c1724b67614d2aa24655395e3323f202f381704" => :mojave
    sha256 "aa67d326b2059610675288a2ff20edb1f156327f8c4399e0d725fed6bb3962f1" => :high_sierra
    sha256 "07b4356f309e74541d37da6c1a619e836e7743ad206e38d4e1ce66204ca03ce1" => :sierra
    sha256 "3c5ebdc4717d374aa9775c137129463fea9d255080e6a90d1380443c50cf192e" => :el_capitan
    sha256 "eafe51016b3b0b08f5af4db3f9a143ec291cdeb1f8dca59285ea90d5b1fb1101" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "YANKCMD=pbcopy"
  end

  test do
    (testpath/"test.exp").write <<~EOS
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
