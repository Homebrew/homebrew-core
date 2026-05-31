class Revelo < Formula
  desc "Read technical metadata from any media file, in pure Rust"
  homepage "https://github.com/vbasky/revelo"
  url "https://github.com/vbasky/revelo/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "c7968fe41c8838ea7f95f9335585adf290033753e89c7d67905f96bd00e26f07"
  license "BSD-2-Clause"

  depends_on "rust" => :build

  def install
    system "cargo", "install",
      *std_cargo_args(path: "crates/revelo-cli")
  end

  test do
    assert_match version.to_s,
      shell_output("\#{bin}/revelo --version")
  end
end
