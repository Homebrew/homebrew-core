class Tag < Formula
  desc "Manipulate and query tags on macOS files"
  homepage "https://github.com/jdberry/tag/"
  url "https://github.com/jdberry/tag/archive/v0.10.tar.gz"
  sha256 "5ab057d3e3f0dbb5c3be3970ffd90f69af4cb6201c18c1cbaa23ef367e5b071e"
  license "MIT"
  revision 1
  head "https://github.com/jdberry/tag.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87582cbaf5cadbc19c6d8c2c9ea6793d3116a119d7de6b18b7b5a6d898b4ffd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68b99acc16647610b02c286aae5b302c7c2128164817d9eb197d2d5f9f51ca72"
    sha256 cellar: :any_skip_relocation, monterey:       "4b70ddf8fa1ead9e8bffdd2d12194301be5c2be66ea3a355b62eee2836d5c0bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "a63e067af22cda164f890108f610bfecd4bc3b2759fd1dd473dac59d1654a156"
    sha256 cellar: :any_skip_relocation, catalina:       "e1572ae47d558d60983f7c1cbe9ae42a5c7f2dcb950762ab6c721e81351f5657"
    sha256 cellar: :any_skip_relocation, mojave:         "ee5dbe68476b6ae900b92486f3dc3c7a9755296c1fee54a75cd64c7d6af66763"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5801c9fac7b1a4bad52f02fd8a09b64050ebc52515bd96115153c7049bd4619f"
    sha256 cellar: :any_skip_relocation, sierra:         "5711ce58bd5b224252f1869f84f937c6bca0775bf4c86a6a1168418c1218dc98"
  end

  depends_on :macos

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    test_tag = "test_tag"
    test_file = Pathname.pwd+"test_file"
    touch test_file
    system "#{bin}/tag", "--add", test_tag, test_file
    assert_equal test_tag, `#{bin}/tag --list --no-name #{test_file}`.chomp
  end
end
