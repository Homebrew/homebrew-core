class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.17.1.tar.gz"
  sha256 "3bc82174729628010d29c85f2d2c61cc45cef5cc729f13153b1422c8f647d33f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11c836187bb6d0fb6569944bd7d2c9a0f815b34fe52bf03195c2b62e4102f913"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d83500db72a7e0dff3fc8fd8e2526e11e6d25a104ab155dc967fcc519a082b50"
    sha256 cellar: :any_skip_relocation, monterey:       "a3bfa9e01ed620bb792fdad1a6edfd03c6a1ed428ac3fa2a939e7cc081de89bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd7198eb2dbb92f608a8a8eeb254d2810182f3d647f303831a5bfeeab5ab51c8"
    sha256 cellar: :any_skip_relocation, catalina:       "52aa742b6924b99190019d0347660734d5c846a8c0e79b5b1e5658f2c1b24659"
    sha256 cellar: :any_skip_relocation, mojave:         "9d243c2296dc406c164045adbedee423c4b0a3b74f9a8aaad1676f1a96e16d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ca6f89236f83d52799189baa14c733c7532e9245834ed31a07d4d367579a45d"
  end

  depends_on "rust" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read
  end
end
