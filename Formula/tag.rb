class Tag < Formula
  desc "Manipulate and query tags on Mavericks files"
  homepage "https://github.com/jdberry/tag/"
  url "https://github.com/jdberry/tag/archive/v0.10.tar.gz"
  sha256 "5ab057d3e3f0dbb5c3be3970ffd90f69af4cb6201c18c1cbaa23ef367e5b071e"
  head "https://github.com/jdberry/tag.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f471e0448fd685efb6c6a3148089717925b8546ce93985d8d67ad0daabc7577" => :mojave
    sha256 "22d6aa5d82d61f6e09cda52b11e404e95006a3103c0a44a71f7cb33a63f90df3" => :high_sierra
    sha256 "1d0743d0202d7d1f1df2ce2eeeb635e6c5554d0e313e51ea92798d6522f99467" => :sierra
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
