class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://github.com/GyulyVGC/sniffnet"
  url "https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "ce52c4be2e35c285b646edc16cd2b58cf0f5d7e8f08e983cfe09e5396d758595"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b1612a9a7d062936b54df764d2c32811c25d721b2513fb24e93cf5cd2d62357"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c05b4de8683896024142934208ac74e415fbe385410b9f59034926c6bbcb2bf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea593162aaf52a412031a37e62720755432361162f38dbfb7c64fa3478419b39"
    sha256 cellar: :any_skip_relocation, ventura:        "690410fa1bd1ef8b32bba5fba72d1d8aa32f4af46fd3d2019f9740b12091e1e7"
    sha256 cellar: :any_skip_relocation, monterey:       "9713533b4fcb3067f676d5c840ffeddcddb852c050f3fac1b91bf2c5010c7fad"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee95ca7e07bc59f1beefe0f9aaf6a54c2fa9cb221ce708d1142092f2d7858076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5ba01823c36bb27171c47310edf7718dd22ca576c085f3b9ac8a9cc1579a239"
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
