class Tag < Formula
  desc "Manipulate and query tags on Mavericks files"
  homepage "https://github.com/jdberry/tag/"
  url "https://github.com/jdberry/tag/archive/v0.10.tar.gz"
  sha256 "5ab057d3e3f0dbb5c3be3970ffd90f69af4cb6201c18c1cbaa23ef367e5b071e"
  head "https://github.com/jdberry/tag.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f1c31729b905f07c0401f39d4e10014363fdd976d26f5ceb0390b233eafcbd4" => :mojave
    sha256 "a956e7444a881bbe4db8f1100e3a6c2913d795291a3522d34795df9ea4a26b14" => :high_sierra
    sha256 "976deacd9ba2533d152a70d4920ce0edab6e22f35fd72f438774c675e9bf532f" => :sierra
    sha256 "f91752c50c52456037e04b7e38c1fd1246edb0086fc681860e71f222c2891df8" => :el_capitan
    sha256 "640a9ebb8fa34d93f5566e2af7e25716eaa2497165c4e7122bcae1d9cd51fb5a" => :yosemite
  end

  def install
    system "make"
    bin.install "bin/tag"
  end

  test do
    test_tag = "test_tag"
    test_file = Pathname.pwd+"test_file"
    touch test_file
    system "#{bin}/tag", "--add", test_tag, test_file
    assert_equal test_tag, `#{bin}/tag --list --no-name #{test_file}`.chomp
  end
end
