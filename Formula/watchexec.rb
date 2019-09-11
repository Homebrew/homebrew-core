class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.10.3.tar.gz"
  sha256 "2bbef078d3937764cfb063c6520eae5117eddb5cfd15efabc39a69fc69b9989e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b09275b1c686404ea57e8c0b52c9f2f52b06bc9cbd6b61935e50ca280e902c1c" => :mojave
    sha256 "9bbda6ac49cb30495ec20ed084d08b636a526578a3ec1df8c7e6948c9b7105dc" => :high_sierra
    sha256 "eda530af03c418d4adbd80ae33922d4912df3eae4ecb5695c4692a21d4cc9af5" => :sierra
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
