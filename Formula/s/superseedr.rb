class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v0.9.36b.tar.gz"
  version "0.9.36b"
  sha256 "37347050aa48653aea2a06ce687b5b7f55664a1e99b9d6296a6687aa3b2c4fea"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac29c118f4da4ee71976704d6130b23725e672e6fa078fd5d59aa3345d9c784b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a99d7f03e15b9b5a78e41505c0adf5c5d14b93ab2b215c30426ebcb4641cbed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e14580e76e1ce2802bce2d107902311c7e02d20954c1e7419d532ba22b899b41"
    sha256 cellar: :any_skip_relocation, sonoma:        "89ff8b525aa06baf4267788faae1f3ee1438ec63fcab6a6234bf90808de56cc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "882e34753205bae9d21e1242260ac12abf56068b2c22c7e29b18b96880b1bc1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce4963761bdf60c3799f7a6b5b236fb2dbb36f0274913ccf2e75574b1a4a0be0"
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
