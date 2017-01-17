class Yank < Formula
  desc "Copy terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v0.8.0.tar.gz"
  sha256 "303619d6658d21a5b1e876e5833e45f1489affc6998dfd0768d2756d3dc45f93"

  bottle do
    cellar :any_skip_relocation
    sha256 "121d007b309be761384d2b4a703f58aa8180b23f6d3583722386c3ea604dd741" => :sierra
    sha256 "8f40f5522093a6440a6cda25d528f068901526138214d8508b79e64fe8b8cb6c" => :el_capitan
    sha256 "d8fe91b44fe32a6b9a2e06c1c81792d30ee14193dfc185b3384f9c4557ee1868" => :yosemite
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
