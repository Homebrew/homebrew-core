class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/mattgreen/watchexec/archive/1.8.3.tar.gz"
  sha256 "e447292f68fe24e1e7b10b0b1c841b2644ad97598cfda037d65756b8e1801c1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "628afcd67e720874c864e0183a6fb84cb2ca0c4284deeaac7e420a8171006d56" => :sierra
    sha256 "2842d7e5b1dfd22dddf40e6fe5f2f48d3ca059a140a4d62c035054194dc7d185" => :el_capitan
    sha256 "011eacf532dda65438f7cb23e60d1b96a8ec4ce22f4f0af14d46369ebbfc4d01" => :yosemite
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
