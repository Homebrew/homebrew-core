class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://github.com/GyulyVGC/sniffnet"
  url "https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "d6ee2f8ac8ffb337184e3f1ed4ae1d71a4a62a6d87065b4901ce725394747584"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e8cb9ccb9c357d147cdbacd2a0f5174691a33e62762ad444f16805dbaed1a6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3802c5cb60cb38b48d1533e0ba5055e3a0f92aa87cc3830035abe9e93b5df067"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bed274251c38c182349dedf479494346f90ddcb43dd14f8a81139d769ff7b3c7"
    sha256 cellar: :any_skip_relocation, ventura:        "d333fcd07692bbf2d27cda50452c45d1b32dfa2456e06101de123f42696ec400"
    sha256 cellar: :any_skip_relocation, monterey:       "852a6d871c1ecb85337474a6650b0634d3c0d5008b03a7269d9bdf3c821c1ed4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d23411868e5df55b6ea1617d78631619f9028f043111e581591f69dde120036a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a17be821729613e298dabc1caef7075970ae97b5ca8d9ea00f2bf9ea60f5eeca"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "alsa-lib"
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pid = fork do
      # sniffet is a GUI application
      exec bin/"sniffnet"
    end
    sleep 1
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
