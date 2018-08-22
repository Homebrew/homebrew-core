class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.9.0.tar.gz"
  sha256 "64a3ade996d83facf5d5aad05667425c3c0293dd7dab82e7675af483f59275fd"

  bottle do
    sha256 "4794aa7240ea6f79a3324b7c1720610c5570623cca529ec129a57836f3ccec7b" => :mojave
    sha256 "1187169dd33f3a96a46e4e47f718250fe18a9876e8d6aaa2a2b470d64d6ea9f8" => :high_sierra
    sha256 "6e0d65a52c506214c0ce5d82d3e3c492224cd5aa33b9eca268e792b5071a2e1e" => :sierra
    sha256 "31ee106d09477b9a6d3d1959f115d7469174b4383bf368bc423ece55e91890af" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -- echo 'saw file change'")
    sleep 0.1
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end
