class Sacad < Formula
  desc "Automatic cover art downloader"
  homepage "https://github.com/desbma/sacad"
  url "https://github.com/desbma/sacad/archive/refs/tags/3.0.5.tar.gz"
  sha256 "4d025914e24fe5b47c8a76f24c7b0931528e4d87df51723280bae2f501f51636"
  license "MPL-2.0"
  head "https://github.com/desbma/sacad.git", branch: "master"

  bottle do
    manifest_sha256 "70b3615930e4b0e63b99664490a8a2bdb3f0fa5f9d24a6ff3719edd22f3dbe80"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "44b33c2fdcd19027c9feb6da67c83af8a716e1d401e3c2ae3ab315749819ff9e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4ba33ac87c6e1c56a87685ec68e8a68a5c0e1735451c70136e2f996bfb88fc86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a571a3b7f8dd7dbf2bd21d9f4edb5564fc21aa8b5ae0b925554658716756c080"
    sha256 cellar: :any,                 arm64_linux:       "7ae86ae611df4fc809156bbb3f2f2ed67640d9c53bf8d7d68f58b8b7616cd051"
    sha256 cellar: :any,                 x86_64_linux:      "6a91d53ac177247d94f19f080812fcf58a346b222b8448c56e2fac02261f5411"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sacad --version")
    system bin/"sacad", "metallica", "master of puppets", "600", "AlbumArt.jpg"
  end
end
