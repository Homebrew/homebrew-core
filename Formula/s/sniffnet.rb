class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://sniffnet.net/"
  url "https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "7f0789836b81ca0ce249d1ebb15493aab3941a5c4438ac1a70784470c0401550"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46fed06d4e0d8dd7262299c6b5b65d0021a5e49bcebb29730c015b483b376dfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27fd97922331f22c22eccb26fc5efe52e0a642773d00a3b7ab16a669d07f431f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ccb4f3539b8ccdefac958dfd9e3146816c54edf424318c7f4cb727ab3a559812"
    sha256 cellar: :any_skip_relocation, sonoma:        "89f6c7e918b397d45735839f5c5f54bcfc7aedf2735fd2648459e2025fd7b90e"
    sha256 cellar: :any_skip_relocation, ventura:       "9203d8da06985da7ad3c0772c125c19c53133d670e36e936a0b0d3b2d54ea7fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be6be965d74bf52ae73509bd308036f547031f0354b81241d64d4981157761a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "955f8fc814e582661667493534b51907957f6146223e567dacaec90fad7ad856"
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
