class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "63b79fbfba6ebff9227ab25e9e4916f1c6c58e0f07779f971856153a06b79dd4"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92f114e84f7eb3f80e28830447c642db3a1f10b89e685314ba94bce4d0b33eec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b43a157a9cd939a1d440fa634d04cc563302563b94ca4c4126e7e8433020866"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5a02b75d1fe7a94612d20ea0d2ecb33e85c132a774dd2933ce492123eefd282"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd2e1e2a0efbca0c4a09131b29d6b7bc8340230cd30223f2e0f64dbe1e9a121f"
    sha256 cellar: :any,                 arm64_linux:   "d61bb35475da8eb3e4702d9f6408eee77033a19213c38c0bb6ae8c4d29936c52"
    sha256 cellar: :any,                 x86_64_linux:  "d0c879b6dc437d64d0acbfc56be3fcbe0d2cb02fc27cc961307151ef8cc8a990"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end
