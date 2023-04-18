class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/refs/tags/v1.22.2.tar.gz"
  sha256 "af12016b1ee1f64feb1514872279326f72b1061c85f3add32997f89a1816dd74"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:cli[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58c73d6d174d7e64f335f68cfef83b9ed2db61aaa6b47ecaa2953f73ae65fbf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b441d9bb50d1913b928d0c34ca64f8a54b97701c879fc56192a04bb7e8907a90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "944561e94a35a0e2b38e120a7ae49dc08d40d42c0d3bf645c26f31366ba3bbe9"
    sha256 cellar: :any_skip_relocation, ventura:        "3a0f27c94d8f8aad11b0d87a7fda65a189840dc643b3431256d8e5950de7794b"
    sha256 cellar: :any_skip_relocation, monterey:       "22066b34ce6e2de9bea5b2955ef9ea14144c7e539d4adb01f2ce3be99a7a7432"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb29e79b2a3b2b25b203cfe55ba11e367a6d1e0fb84545e71762009c9e8d28f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5078afdf2d5c03e604826d3592ddef3675fcbc4a58bd3274499a4b1e7c162cb2"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
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
