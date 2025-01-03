class Termbg < Formula
  desc "Rust library for terminal background color detection"
  homepage "https://github.com/dalance/termbg"
  url "https://github.com/dalance/termbg/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "f31a6b0af7b2833d31481197f80e2cef9dfe7196ca640367d8f63ca6e03a3d0d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dalance/termbg.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"termbg", "--debug"
  end
end
