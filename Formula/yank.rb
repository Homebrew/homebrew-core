class Yank < Formula
  desc "Copy terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v1.2.0.tar.gz"
  sha256 "c4a2f854f9e49e1df61491d3fab29ea595c7e3307394acb15f32b6d415840bce"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef4da54ce9a56a1767b44dd88df6616c147730d74f390d5a661910dddf8785a7" => :catalina
    sha256 "60431f02c576c640597975986ce62f9d157c49f160d7d6e23f917dc321ca8bac" => :mojave
    sha256 "b87461e809f0bebd615d4da69c31509109de8f86d07d280dab07326293cc851f" => :high_sierra
    sha256 "70a5de45249c1656653733fea8d7a92c2496b9ba8e7540eef86b3f805d0e933a" => :sierra
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
