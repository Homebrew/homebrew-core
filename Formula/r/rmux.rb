class Rmux < Formula
  desc "Terminal multiplexer with a tmux-style CLI and daemon runtime"
  homepage "https://rmux.io"
  url "https://static.crates.io/crates/rmux/rmux-0.10.0.crate"
  sha256 "116b669b1cf4f994f6296a3aa5b329e14c6af26390d12ac0741e2aa31481b630"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e9047c0ddac0865a462f0438e3109f8fc1a84e8d7699686621a90b3dc496fbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0acbcfa31d5c236eaf8f8bacbfae1df60dc09119f076cf34d74dfbc041d706a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e6110796dbdd7e961f2ce0ba9c8a770bd5ea4a1d19ced090a02e806b4556156"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7c2fe5be7f2c0394aa84dfda211962d6fca25a9c364119c71564e650d687ffd"
    sha256 cellar: :any,                 arm64_linux:   "b20e8c622173ac28b7ed37303635f88dc7869e04bc68828d073274f6a07a6ad7"
    sha256 cellar: :any,                 x86_64_linux:  "3cc47a2ae16c11c1a82040360c54d6857f56d69d808161d6d453abc7d52d63ba"
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
