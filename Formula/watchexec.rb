class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.11.1.tar.gz"
  sha256 "6d74f336d6734c7625ee5acc5991f14bc0dff8e7cac40cb11303a5ef2f232f5c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "eed083352cf7ed682acc1e35babc9f410f3b17fd403a7dbb816dc312242cf741" => :catalina
    sha256 "66d0ff90111182e9b982f76157885d5c7bcd8fd795eeb322bdf86868d7433ab6" => :mojave
    sha256 "0b44845c30c08cce6a218e11aae9d635b7dbf195165a3c2e43798a4ea95813ef" => :high_sierra
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
