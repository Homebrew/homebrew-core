class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://github.com/GyulyVGC/sniffnet"
  url "https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "c7134ced27ca3f8ae495ee2811644ad3d80bb2baad7a19c3e9144fb28e3c0e5d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a92e38b3453c50ee18c24c24c475fef078301db09d78ff334ed3106b8c0697b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b92f7865201ae84d768d1822e96e35335fa404cce855d2d623ea7c94b013be0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af7bac80e02457c9173b774980145fab59f7b8ee8a6118b5b77f18e072d06c5a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c67555ea0d6cc3fbba292ed3f9533a82368c0bf36251e0940d328e9d23f0623a"
    sha256 cellar: :any_skip_relocation, ventura:        "c532f609c36d1ec42306b7e995dc1af1a63b3d03112e45eb415661ffee91ce67"
    sha256 cellar: :any_skip_relocation, monterey:       "958e8e0b233414ccd4e93d3e4fffe2ee99f93048058a23fce1ffab7ea715b94b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "845dce3d34f7acee7b6191be6b09ee227e638bdda0d1440d96a7a6f59e03976f"
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
