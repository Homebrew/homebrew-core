class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.12.tar.gz"
  sha256 "a9ab9031fa3e19c70ff8571e41262b6801d4a99dc78307af76e937c4c4f6b01a"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74ef03212901073d244f72d2e228cb3149938fd94f32bbaf95d3483d51ab66b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a44fe32fc737a04f3e749d5df53521039a8256d11b3d3b2e93bebb83a59f4641"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4700b8ffda9ae16f37c4a11e74f92a8eac5aa643c3dd3640e327baa523c9852"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd70c1760125fc8831d7dbbc1d4ce2e45a0071cfae1ea6496c5db1a952b7e438"
    sha256 cellar: :any,                 arm64_linux:   "e70fcc34b83db392588f5315fead19142e5f234bf08f9faddd7cafd58f9fe50a"
    sha256 cellar: :any,                 x86_64_linux:  "45a041e7246ee85aeb980c7231df191c0d823ea4ce2beb6368c646e7454099ad"
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
