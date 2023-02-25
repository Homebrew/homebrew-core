class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://github.com/GyulyVGC/sniffnet"
  url "https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "0e2752afca87164171b5309f0785458f097d6a6db74dac270c6a3e393cbf6cfd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9dc438f0bb029eb1f2baa91c740ef683326e4992a7ff416038af57b18b6c77f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f76556ac64b7220fd304379e5699f0737dbecf6683b47e628de62523da66a98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd0f32d940428854c24f2c2313f15047dd561b7ab28e2dada90dba717a4d64f4"
    sha256 cellar: :any_skip_relocation, ventura:        "18f0767b2bdb115ca9843cfa4345cc4ba4e14f9d6ec1eca1bee09755ff7c82f9"
    sha256 cellar: :any_skip_relocation, monterey:       "12a78b946e272b4a760a078cda42743ae745f6594e120301e1adcbd99d1716fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "93a4ad15aba67a07714b9f7a4f61eb9bf12ae483d33c830d1ce63b76d33bec39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ba329a6bbb980fd68a1c9c5b72f8a32bdfbe329aac7a54baa74e5868e6a8fe5"
  end

  depends_on "rust" => :build

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
