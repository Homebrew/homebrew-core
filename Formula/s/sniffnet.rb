class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://sniffnet.net/"
  url "https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "7fc4cc610a2bbd823604abe6acabceac2cbeb9d42129851df9b6b24cc24d05c7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a6044656799fbb1c3834c323e39fbb4564d54716bacdc1b1324487a3c0642aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "792d9b7324c83a420008db4d9f5411ba7caa18e91a54e0e0fcdf7eff3058d724"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b8c49b200bee621d64aa6825fefe1a04ed6b3af360d784b4d2b6940c06e6569"
    sha256 cellar: :any_skip_relocation, sonoma:        "628b4d505e61357664fcfa85193e755ebd59b04b2f72f6944c2f6bbbe0dccf48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3d3d86d6d894281e8fa2c7d4e0bb9597254218a3d1dfbe96356bbf97a33b0eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a245e62ff02c4d56dc2588888c03b728165b1348c13e031a0c2080b0756f3dc"
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
