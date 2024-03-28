class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/refs/tags/3.1.0.tar.gz"
  sha256 "71814d6f5bbe1e039c89333bec2131c1b56f4000796fcdab3026ff6820ce59a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3e1f2bb9fb14138f801cb912537b91cf35b1be55b6c20a6b005b757f6e967c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43464eb5acde93520eabda718387363a2b820868b7b2a34694fa9a5335785a97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8545bf69429de1d486b07f340ddbbec6738123909d2d0c288634aa8f056b638"
    sha256 cellar: :any_skip_relocation, sonoma:         "2dcc25974272a0c82d5dbc5b44648c0a9ea2a0dd2c0dde37b3e2352cacd672f3"
    sha256 cellar: :any_skip_relocation, ventura:        "9ef67a2ff5a5225f320fcf23faa4d5ac11e2fd379f081383dc24111469f5fdf8"
    sha256 cellar: :any_skip_relocation, monterey:       "031b470dd898029ad1d3dd759d293acd30d15d636c8d8237f05eb7a80a5a5696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "251a85940fa1538988a0e03be305bfeb29937b98cc0242d40bef3bdceed9dcf5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
