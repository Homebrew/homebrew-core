class Sprocket < Formula
  desc "Package manager for Workflow Description Language files"
  homepage "https://github.com/stjude-rust-labs/sprocket"
  url "https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/sprocket-v0.5.0.tar.gz"
  sha256 "7ba97b1d2d8bb136f47c7e4ebfe572dd42cd984a5f62c9d4c9d4f62c14458a56"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/sprocket", "--version"
  end
end
