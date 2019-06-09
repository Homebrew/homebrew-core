class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.10.2.tar.gz"
  sha256 "ecc00e43ff2b3404ebecf9f6d0c7115f46905de07df31b573281fe4d58169869"

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
