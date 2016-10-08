class Yank < Formula
  desc "Copy terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v0.7.1.tar.gz"
  sha256 "54be76ced7c68fa1f45bb18b66a62777e975c6febf32c9c4c0c9d9611297f717"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a935846cf2a73a74a4f53d2127f0b024de5d082bd6611a834a2ae2ec19cbdf6" => :sierra
    sha256 "53582c4786f7970e28f0d43a55f70e4fac50584833de4475526c26931f3b97e5" => :el_capitan
    sha256 "e3ba33e83d3b58a6a70d815977a6be77a357622ac39eb9f8ea832804dd4307f9" => :yosemite
    sha256 "a491314e9ecf256192aef5867f450dc328b0d49a4d92f764036c09496c1ce36d" => :mavericks
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
