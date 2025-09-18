class Tag < Formula
  desc "Manipulate and query tags on macOS files"
  homepage "https://github.com/jdberry/tag/"
  url "https://github.com/jdberry/tag/archive/refs/tags/v0.10.tar.gz"
  sha256 "5ab057d3e3f0dbb5c3be3970ffd90f69af4cb6201c18c1cbaa23ef367e5b071e"
  license "MIT"
  revision 1
  head "https://github.com/jdberry/tag.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "dd8bc8fffd2b86efc0a22070b48426c82f98979625bf991332a633a83070cc85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0276d10f3dbc55011085ba7d45f74a29760a8985108e946be3d2c6abf0bdfb34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22c9b07c4317b1d90da2431a3679babf1381a98c6c1311f565bdd83b94c88389"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f02aa65b8800efb9bc93089aded8bff111549d41f28e7ba223b02a1240d5c7b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87582cbaf5cadbc19c6d8c2c9ea6793d3116a119d7de6b18b7b5a6d898b4ffd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68b99acc16647610b02c286aae5b302c7c2128164817d9eb197d2d5f9f51ca72"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd6e785addd1fe6d8ec7c6fe81b17550a0fab220c6bb54a1ae358990dcd1d549"
    sha256 cellar: :any_skip_relocation, ventura:        "b8b8096c01415421b0b68db1e01003d7ce635db093f5f00120dd133055f782d3"
    sha256 cellar: :any_skip_relocation, monterey:       "4b70ddf8fa1ead9e8bffdd2d12194301be5c2be66ea3a355b62eee2836d5c0bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "a63e067af22cda164f890108f610bfecd4bc3b2759fd1dd473dac59d1654a156"
    sha256 cellar: :any_skip_relocation, catalina:       "e1572ae47d558d60983f7c1cbe9ae42a5c7f2dcb950762ab6c721e81351f5657"
  end

  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    test_tag = "test_tag"
    test_file = Pathname.pwd+"test_file"
    touch test_file
    system bin/"tag", "--add", test_tag, test_file
    assert_equal test_tag, `#{bin}/tag --list --no-name #{test_file}`.chomp
  end
end
