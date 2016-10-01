class Tag < Formula
  desc "Manipulate and query tags on Mavericks files"
  homepage "https://github.com/jdberry/tag/"
  url "https://github.com/jdberry/tag/archive/v0.8.1.tar.gz"
  sha256 "4ac5005dcffff4f03fe3885b2ab321a61d77df2fb862527f4a0d05d1f9280680"
  head "https://github.com/jdberry/tag.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e96f388c073710ee630ce6437758995ab4f76df047b31a70cdfc45d050e1916a" => :sierra
    sha256 "7406b17715a627677917d75800850bfcf52b5796584dfc90f5e17d67a01cf4a8" => :el_capitan
    sha256 "ae93b14ff99a6e0827359effbed9ca31f148affbf28f6d212bed39232023e1eb" => :yosemite
    sha256 "8aa970a198d4c14b310d0f2ba5dcb238699d44585205137061a21d0e7690d629" => :mavericks
  end

  depends_on :macos => :mavericks

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
