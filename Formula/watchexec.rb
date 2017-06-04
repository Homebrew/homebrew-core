class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/mattgreen/watchexec/archive/1.8.4.tar.gz"
  sha256 "ac5f4baae80de5ae99e44be328b2d9e75672250ba38a8961c90120063fbb3fed"

  bottle do
    cellar :any_skip_relocation
    sha256 "dde0b2b1e4a4a52ae62416dd9223726671bc3716d42e772782cd9849d799a12f" => :sierra
    sha256 "7fdf03c85807f5e54484dcb0d78b7147cd4f30fe57a62c685cb0da4c828c3554" => :el_capitan
    sha256 "e04b185a12ee6afbc0eb9356dd2603a327aef090abbeac2384b8e971986586e8" => :yosemite
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
