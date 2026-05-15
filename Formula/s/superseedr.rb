class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "93f6bffaa5d77a7a07152beb34e4a452da59eccc24d658b0e0402b73ae68dda1"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25649fd518d0a812709d8b3b2879aa1dccae64e1a2ec8a05af66ff443b4b8312"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f998a8dee477344d829a2f1b750cba9d8c05021be8b8f6b2614d30b70a39fcdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35fc905f03e40a750ccd383dfb6359b4a7c5be7f403a0f5d7c0c41750a051980"
    sha256 cellar: :any_skip_relocation, sonoma:        "f016a9f0c3813396fb82e26bf191f506ef58fb7c8b22adf361d77b2d02cb8321"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c49db3d86b98f58dabdd6cffa7b68340c0d0de4972ec52a41358dca879aeca76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29e0a9f1a2a8b1acb152805e7650758b83956ec6d3b1683ce1ad692229cb0158"
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
