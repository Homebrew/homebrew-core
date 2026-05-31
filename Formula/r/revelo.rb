class Revelo < Formula
  desc "Read technical metadata from any media file, in pure Rust"
  homepage "https://github.com/vbasky/revelo"
  url "https://github.com/vbasky/revelo/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "7b436aed55b2ba73676e80da98a7d721115db56b3d354bff58a7dbe71ad50763"
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
