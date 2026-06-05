class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.8a.tar.gz"
  version "1.0.8a"
  sha256 "fc539baad98f403210f01ccd5f3ed2018b534e430c7cbef2dacbc049a49b6171"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9f929488ffb07ed1df65f10edc9e7ab8ca5afdbf24f156b2479638aef108d2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4139020764b3d254f5821741db30a8e92ff52a7e44b6bb66b8345215302a2162"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73e2aa6d8bee4ba4a44c4b7c516c101916cd045aadb5fd683ec2278103987744"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2c5ca1ba5acfada214ce228205ccaea1569d9bd0bdac5e668b0ebb14ccdc528"
    sha256 cellar: :any,                 arm64_linux:   "6fe004211a7e63e9efa7556dd396585da927341e7e9a241061392725aaed14a7"
    sha256 cellar: :any,                 x86_64_linux:  "cce0f8fba448f2ff186a42c55f44aa2c582c81aa60e88094b454dc92f801f279"
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
