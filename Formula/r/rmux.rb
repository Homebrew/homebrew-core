class Rmux < Formula
  desc "Terminal multiplexer with a tmux-style CLI and daemon runtime"
  homepage "https://rmux.io"
  url "https://static.crates.io/crates/rmux/rmux-0.9.1.crate"
  sha256 "fb7348856ef262bb9424ccb33af3d0b72212c378f32edad3a31b35d3b5565ba5"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e9223530e8d89646abf415843cb51ebcee6fc6ebf62a858d29e7ae31498accf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc011dd64aaff920aa73aa38bc3dfefb2ebe0c4e593f40801da10e8d64d464ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3e837e61ac76ae06d520b6c240a3505a12ef68f588893e3ff7887263f3bcd11"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c5bff87dd62baffde74e941cc094f77bfeb5c4f91ed8b4b049b1a83448deca9"
    sha256 cellar: :any,                 arm64_linux:   "54fb64e3bf99ef52cdc810142185fed75f65b574c27b423c068a6a1efbf2932f"
    sha256 cellar: :any,                 x86_64_linux:  "5ebef24659d8ea4042146023546f59c3ffcf220ee6c649ceb1d804f9df9d4a14"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/man/rmux.1"
  end

  test do
    require "json"

    assert_match "rmux #{version}", shell_output("#{bin}/rmux -V")
    diagnostics = JSON.parse(shell_output("#{bin}/rmux diagnose --json"))
    assert_equal version.to_s, diagnostics.fetch("version")
  end
end
