class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.17.tar.gz"
  sha256 "f3d0f61aa910631d03f3cc649a8f7f80a5d838618902d5cd3e2bd577b330922e"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2be13009e012232ed9c3d317919030a86618f66d6e6b9d63a3387a8fd2ac127"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d07c73721cfe6ede7e452f0f1cd64629b1af2ecb4dcf4a91309ecd61ca09fce6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f72c7b38c20f1cff1e8cd632ec4c0c54798d16365401225935feb618990294f3"
    sha256 cellar: :any,                 arm64_linux:       "de744245fcd34868bce5346fc2b81466418ab96f803b69e0358dc3a9c1da3dd6"
    sha256 cellar: :any,                 x86_64_linux:      "1f6edf8787e272a15d23881e781f42e3b55f3ea2d3a36c34403d8fead912ec00"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end
