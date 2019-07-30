class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.10.3.tar.gz"
  sha256 "2bbef078d3937764cfb063c6520eae5117eddb5cfd15efabc39a69fc69b9989e"

  bottle do
    cellar :any_skip_relocation
    sha256 "55c07c92a1e2616da9e421b2e62202f2c68d62d455fd04b29fe186f73bf6a463" => :mojave
    sha256 "21933e42907e02364c23bfef3aa9076d169af0ecefced6dc05cc7aba341a2845" => :high_sierra
    sha256 "eb912bd873956511ee27c42df6d24c926820421f201a9e46808585b2fdf01ad8" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -- echo 'saw file change'")
    sleep 0.1
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end
