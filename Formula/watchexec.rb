class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.13.1.tar.gz"
  sha256 "b58375168233501fbdecad1737053a66eaf3b6c4aef0f5f39bc452a3eefb93d4"

  bottle do
    cellar :any_skip_relocation
    sha256 "43c3f38e62625349663cd00cab118153a4140f146dace6a330af33d1d27fc166" => :catalina
    sha256 "79daa1917e6d83b149ee92827707089e15e43aa09b89d79af39aca63899cd9a7" => :mojave
    sha256 "9a0593e6b952996d1d6dcab6d83d39218ef0218486e442b5bd1e0e79cee7dbfd" => :high_sierra
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
