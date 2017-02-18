class Yank < Formula
  desc "Copy terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v0.8.1.tar.gz"
  sha256 "94fff79aa635ae497f52128e688c25c19596035f1358c660fc6826ee8a6ffa41"

  bottle do
    cellar :any_skip_relocation
    sha256 "876327f25cb580065995f4f9ee34e05b17394df37e785c5efab2312e8477e4b4" => :sierra
    sha256 "f47a30b52cd1fcc861e38c4252d8b7bf889e2adc874a1653f28c7d0797600dda" => :el_capitan
    sha256 "35a1728fd3626c612c9834c46373a1bb0596bd154eac78fabab6b1c3872b0c5c" => :yosemite
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
