class Vmtouch < Formula
  desc "Portable file system cache diagnostics and control"
  homepage "https://hoytech.com/vmtouch/"
  url "https://github.com/hoytech/vmtouch/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "d57b7b3ae1146c4516429ab7d6db6f2122401db814ddd9cdaad10980e9c8428c"
  license "BSD-3-Clause"
  head "https://github.com/hoytech/vmtouch.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "08b363fa7ab899df5673f242967d7e8b07854c1403c04edc47bc4d3738f12d6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "71ea80f43e78935336818c646b4561db14301e5590d0e726f221a944cb9efb73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af6dca4823cffd3272dce9a60743bfe9d7fd9a8bd467b3ae55ba370b8bb37d00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "291bc54c646fa540129601fd7dad8a46756f8bc739a3cd505e5d8241a0000177"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c301e4360ef07fffe67a5860df289c3ec091bb4c51793b65054370b6a997040b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d55c8a93a6826d78dcd439155de21e3da33598bd00c022e1fb4d39635f12c53"
    sha256 cellar: :any_skip_relocation, sonoma:         "74d32e30b5ef6ab2e3d1c22a227aad8a9bbd16d26be101e00ae12321ff4d3e12"
    sha256 cellar: :any_skip_relocation, ventura:        "748e2395fb262337812098a9add42b3389469f4e084a4c9139f7350f8499262b"
    sha256 cellar: :any_skip_relocation, monterey:       "10abb43d5b8bfb7ed49edd377f826747cdb58d6db5ecf91e58223d6f8144ffb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "89ed86d067750e6bf19a6a79d7f3b9c3b2ad2e39795f174ba2452d11d43f650e"
    sha256 cellar: :any_skip_relocation, catalina:       "30c620a4dc06285c41c7194468de50cf0f12aab38c6441d8e1bbad6d4231ee1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "51eb867695f92dce54b46d64c23ce16cc9ea3a2fb59b581de5785ac36b96a664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "370429512a98b307f32755176f1bc39b988f6c787f24bbd304dd95f20b7c399d"
  end

  # Upstream change broke macOS support in 1.3.1, patch submitted upstream and accepted.
  # Remove patch in next release.
  patch do
    url "https://github.com/hoytech/vmtouch/commit/75f04153601e552ef52f5e3d349eccd7e6670303.patch?full_index=1"
    sha256 "9cb455d86018ee8d30cb196e185ccc6fa34be0cdcfa287900931bcb87c858587"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system bin/"vmtouch", bin/"vmtouch"
  end
end
