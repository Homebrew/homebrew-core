class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.18.5.tar.gz"
  sha256 "ae4b2ab209e342c981ab186e3581b95f7c43856aef037196747b6e4c33f8f3e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de04e69d76b03fc09ea65cb23a8778ca8c200dcc3dadab9b44708d9b36287859"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "276b32066671693a123fe1995d1b6a05826a589620bce069d4791a9ff0ad876b"
    sha256 cellar: :any_skip_relocation, monterey:       "0619255ff0d4be3b7ef87506b4f8d5258fb8bebb1fe01ffdea3fc012df324ac7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8acfeb8d2c6105cbadec7fc6db946b49f333368131159492f9cc54cb9fbb762b"
    sha256 cellar: :any_skip_relocation, catalina:       "9d1da702bca6f06e5f7bfb525090af817736c84d4c284cf91ae61b1c3aaf8b8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5d5a2911549eaa4949b8608dffdd5ded7f0ebdc235b3e0de43a5c595dc1d573"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

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
