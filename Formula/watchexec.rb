class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.11.1.tar.gz"
  sha256 "6d74f336d6734c7625ee5acc5991f14bc0dff8e7cac40cb11303a5ef2f232f5c"

  bottle do
    cellar :any_skip_relocation
    sha256 "db7221c9f60907b69c70ef8eaec1a5b2e60b5b0b2b9409f2603c3214bfd2889e" => :catalina
    sha256 "11ae8b596e0a14a6efb1342b5e497fb9ccfc75434b8275907bddc8116fee5196" => :mojave
    sha256 "e2a83d838b24aa29b8d0a7b1dff87bca16e1269c1c36f87e20a913f27530bcdb" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -- echo 'saw file change'")
    sleep 0.1
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end
