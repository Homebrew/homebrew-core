class RvR < Formula
  desc "Declarative R package manager"
  homepage "https://a2-ai.github.io/rv-docs/"
  url "https://github.com/A2-ai/rv/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "517e6d5c62ea0bed7e76903d2ca71a28c50b6d7b2f9bcb962be854c02c069353"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac7b78aff81ec77616e341e8af73c1a66a6adb3fbf2c656cbac949178065d378"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f0f9b2d5d7265c82415c8fcda59062dc0b14a955e87e682602958a53f0c0269"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbcd5130350623992da26cb89a14149eebda4d0c6142abb8aedc85495af9f0dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5534f6d3d92114c94199b13574507c95dc0c0b942f7df68e08991121ab87fde6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff19bee0d0e44a764b693afec199ddc0c12c2678377fcac7a8034826c7e00088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c7ac471fc2526a294c145c6be331e8a5e75623a824cff4d2eba9c3a275fe22e"
  end

  depends_on "rust" => :build
  depends_on "r" => :test

  conflicts_with "rv", because: "both install `rv` binary"

  def install
    system "cargo", "install", *std_cargo_args(features: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    system bin/"rv", "init"
    assert_path_exists "rproject.toml"
  end
end
