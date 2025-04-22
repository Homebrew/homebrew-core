class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://sniffnet.net/"
  url "https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "92ad92196245f36df9380091623beceb7ba4dc1d3b7f0844791c0dff302a3a46"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2609e62911aebd894cd36891beb8e0ac93e3ea6f7cca899bf4b6af97564ad65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3404a406a6c48f5f35d97d9a2e3e383bd56214d928643456994b025d91e89d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "848d8a0dcb279614da33dd84b0a996622718b943f73747d06041b09e976e74c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9d4a0118cecb9c689a67777d8f9f755610bb9220ccdace535ef76c3c21938cd"
    sha256 cellar: :any_skip_relocation, ventura:       "5275d58ab13e3f747829436216a8e8906847a6f38152c7e0e07078355b8ace4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b5cd32a6492908157ac2f21540cfa986b0462c510ff6c291ea20e4fd65a0fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9c54e12d99526592752f2afab1de70b7fbbbe51712b3228b67d1a7ca6ad2623"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "libpcap"

  on_linux do
    depends_on "pkgconf" => :build
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
