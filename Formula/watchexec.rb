class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/mattgreen/watchexec/archive/1.8.3.tar.gz"
  sha256 "e447292f68fe24e1e7b10b0b1c841b2644ad97598cfda037d65756b8e1801c1e"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e2c7500c2839145973c57eca824267e5f564f5d3bdcb4c375facd430c0e71ff" => :sierra
    sha256 "d1f1e16a99ede3872d78cad4cdd2f1e571276bebf9a49a65f46f11683d5add60" => :el_capitan
    sha256 "7ac4642812fe13415513a3b394c6f0a0bc04b40165f8fa66dff43e2372470fa7" => :yosemite
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
