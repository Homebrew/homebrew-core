class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs/"
  url "https://github.com/starship/starship/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "f1887ffa88a7ba437d2932501794047e28d03387996f7d1c364631c053cffc44"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ce4d6a7171702002de9de0c1f0f2cbbf6e46e8b627882bd097be51bda2261c8e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5596b44bbc5d3fd3a0d117cffeeb2e5b7710855c9e768541c11ef0f594986d13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bbaae04855d3a75553209921f69ef49e401a4065542a20989e8239e1cb4f9bc7"
    sha256 cellar: :any,                 arm64_linux:       "6b2b9ee48edce6eb4076c3437d81cea3f0714db3e3aa0ad7700ba834a655b0e9"
    sha256 cellar: :any,                 x86_64_linux:      "bdb4bfbe8fe61023916c87649f7fd1c2d7320cccbee35db1d2d4bd5c982381ab"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"starship", "completions")
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
