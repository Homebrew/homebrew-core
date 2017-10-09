class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/mattgreen/watchexec/archive/1.8.6.tar.gz"
  sha256 "4caa882a17d3e826dca92af157382145c599ac204e9b9ea810dc309402a200e8"

  bottle do
    sha256 "1187169dd33f3a96a46e4e47f718250fe18a9876e8d6aaa2a2b470d64d6ea9f8" => :high_sierra
    sha256 "6e0d65a52c506214c0ce5d82d3e3c492224cd5aa33b9eca268e792b5071a2e1e" => :sierra
    sha256 "31ee106d09477b9a6d3d1959f115d7469174b4383bf368bc423ece55e91890af" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/watchexec"
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -- echo 'saw file change'")
    sleep 0.1
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end
