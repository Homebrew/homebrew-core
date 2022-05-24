class Xpipe < Formula
  desc "Split input and feed it into the given utility"
  homepage "https://www.netmeister.org/apps/xpipe.html"
  url "https://www.netmeister.org/apps/xpipe-1.0.tar.gz"
  sha256 "6f15286f81720c23f1714d6f4999d388d29f67b6ac6cef427a43563322fb6dc1"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.netmeister.org/apps/"
    regex(/href=.*?xpipe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bb830508ba49bd08eda1641ec55c222ca621ad65dc03a4d303fa72568e2c914"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5a7857c05557eb2e23d8f44f5c2f071d561bd9d9940b50c14899ce94dad3571"
    sha256 cellar: :any_skip_relocation, monterey:       "9f57fd6ba84b400fe4d64af2795ea93cda64e4c8a33ca2ce4b13b8a9c06223d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "694220876bc71c8df56ddb0c87465bffdcdb044a9134269b1185a8f51c50048c"
    sha256 cellar: :any_skip_relocation, catalina:       "d21cc9001d61926df6d08d74e15fa13bf6374c8b0248c129122de343468dd910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1fb6f5f72fbbd4ff9ded0038aaa143230461f90292521cbf63df97c8d050fd2"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "echo foo | xpipe -b 1 -J % /bin/sh -c 'cat >%'"
    assert_predicate testpath/"1", :exist?
    assert_predicate testpath/"2", :exist?
    assert_predicate testpath/"3", :exist?
  end
end
