class Yank < Formula
  desc "Copy terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v0.7.1.tar.gz"
  sha256 "54be76ced7c68fa1f45bb18b66a62777e975c6febf32c9c4c0c9d9611297f717"

  bottle do
    cellar :any_skip_relocation
    sha256 "78807c3fddca82dd00bd8ea58fce5b51451b952af3790a8033eacd96e43e708c" => :sierra
    sha256 "f2c9df83f153aa5b299d8cedf29cf7fad2299a47f16e52d8555ed89aec529efc" => :el_capitan
    sha256 "c3290bfae64a4a5eb1857c09cc2c678063840361dec12f477221385744e74788" => :yosemite
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
