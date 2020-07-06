class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.14.0.tar.gz"
  sha256 "605f58028adf7a9fac42e992633e6291503eefbbbef056607b4b90ed71931f2b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9fde64c4686cb698694de2a08b007248859d7bd80b20ce539dfaf9d5d403acf" => :catalina
    sha256 "e16c18b5a3f0b853b5e966aa29e274c6da83b528c76843fbff558dd216974b94" => :mojave
    sha256 "69a4a23a68b64e2bc1b5796b4a30f8a6cd1abcff70209d87cf3165c99b7438bc" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 1
    touch "test"
    sleep 1
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end
