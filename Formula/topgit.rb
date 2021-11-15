class Topgit < Formula
  desc "Git patch queue manager"
  homepage "https://github.com/mackyle/topgit"
  url "https://github.com/mackyle/topgit/archive/topgit-0.19.13.tar.gz"
  sha256 "eaab17c64c95e70acfcc9d4061e7cc4143eb5f6dbe7bc23a5091cb45885a682c"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f1d4fc904d11ddc99f4a774692587c24e44c210c64a94955ffb9fdd4c53a555"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end
end
