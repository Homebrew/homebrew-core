class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.18.7.tar.gz"
  sha256 "d187365c40e1389a7e1c492e55c73c560982b473d60cade0a2c5c8ac7b59a4e1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4844bb6a2385e761e28b4c86324fc6df8349c4d66bd40389567a267a9754ac60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68d702281c0ba41950039d20261dbc9fe2a92b375af8e1aac621fca3df0c2687"
    sha256 cellar: :any_skip_relocation, monterey:       "277c514ee23bad293eecec8439b71292c6979b04107cee90138e20fbbc0556cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "72c33c237f84e9b68c61206458d1879ff5d743c911a7a12bfaa1803a6732fc9b"
    sha256 cellar: :any_skip_relocation, catalina:       "424e1f75af8d294a37a5410f2d9bca4321329e01d874085712d75ca0d2b2aa26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9148332a2a31ad9e4a1000282f4cebcbb361f305cec029f858653f0c2024cef5"
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
