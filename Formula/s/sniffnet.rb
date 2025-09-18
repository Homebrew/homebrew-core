class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://sniffnet.net/"
  url "https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "920ad7aae75af8bdeed501eb726e9b97d0c07b077d29c2a4033b7ad7c45d9b4d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df100e7607ff41c624db7d931183a9e9ad9acd19a478beb34d61de1dc988f630"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0659849312b257c8ca607aac43a8e660c9b313e2d363d5e74a7361b0333a3284"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcce0cc31651fddc6cd043d11ae3ae6003c69ed3890afd0a1671bf561bbeca2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9954528f8e520f8958b4122da7d45ae4a9670f734699d04e37368040553d0ee2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a9226366e1f55a03c8a6a7b950aa275909412a7f639198e64e77ad8adecef1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7662a1c343ccacf72b5a3d78db8d8cfcb194dfda8403eafb96b188f0ae415a6a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "alsa-lib"
    depends_on "fontconfig"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # sniffet is a GUI application
    pid = spawn bin/"sniffnet"
    sleep 1
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
