class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://github.com/GyulyVGC/sniffnet"
  url "https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "535a7002cc0f394332a4f6b2338e55c00b802a59bba11978442f5fdc714edede"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4702ec269621cdfc8eedc0dbacec93782ccabe7fa4f57e80b0e8692a33c2f6ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1f464910eb959f955c48730113013fa41b5d723d071aaca24a5542171a25813"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "842c709a2aa21fc5f4a461d30b5cf7b2a5a4e02e8a8cf96194b8fd41f7e69a87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e40a1bd7e0329cb9f825728903425583c7e7d1f0843621c7bbff42bee2cece01"
    sha256 cellar: :any_skip_relocation, sonoma:         "496dc80cd9b3f558ed951e70ef981af72856ec3e1ce054d641b2661ad46d0493"
    sha256 cellar: :any_skip_relocation, ventura:        "438b477c5021fade1d9b8d3f7621ec236ec5b267406ce137621f822c810665fd"
    sha256 cellar: :any_skip_relocation, monterey:       "724c8c13c31ea6958e0660aefbd6769c865c615f48c762a50aa775d9e3a4d3e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c0755e0b4d6b472940da5d15b977b86fa283a9035804fb13e45a66353cf0c6d"
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
