class Tag < Formula
  desc "Manipulate and query tags on Mavericks files"
  homepage "https://github.com/jdberry/tag/"
  url "https://github.com/jdberry/tag/archive/v0.9.tar.gz"
  sha256 "ec2e3df36e18d4bd17f8fea34c1c5b9311e23d220e4ad64fc55505aa4c4b552a"
  head "https://github.com/jdberry/tag.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "976deacd9ba2533d152a70d4920ce0edab6e22f35fd72f438774c675e9bf532f" => :sierra
    sha256 "f91752c50c52456037e04b7e38c1fd1246edb0086fc681860e71f222c2891df8" => :el_capitan
    sha256 "640a9ebb8fa34d93f5566e2af7e25716eaa2497165c4e7122bcae1d9cd51fb5a" => :yosemite
  end

  depends_on :macos => :mavericks

  def install
    system "make"
    bin.install "bin/tag"
    man1.install "Tag/tag.1"
  end

  test do
    test_tag = "test_tag"
    test_file = Pathname.pwd+"test_file"
    touch test_file
    system "#{bin}/tag", "--add", test_tag, test_file
    assert_equal test_tag, `#{bin}/tag --list --no-name #{test_file}`.chomp
  end
end
