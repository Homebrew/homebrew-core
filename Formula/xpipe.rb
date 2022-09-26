class Xpipe < Formula
  desc "Split input and feed it into the given utility"
  homepage "https://www.netmeister.org/apps/xpipe.html"
  url "https://www.netmeister.org/apps/xpipe-2.2.tar.gz"
  sha256 "a381be1047adcfa937072dffa6b463455d1f0777db6bc5ea2682cd6321dc5add"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.netmeister.org/apps/"
    regex(/href=.*?xpipe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff3737240646e704e40965973bcc09cbca5c9f9679bd3d5c1643132c521c30e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e81ce041bcf004a2a6292584a4185b35b6b8537c6ce62c2d307d841eba75606f"
    sha256 cellar: :any_skip_relocation, monterey:       "da429b8898c33ced95e37856c153d773317b75349b432ebaf8e06008b5a764b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "7313a4c84f5abc49cd42d467ba5e25216a7ed6be9945fca33b4c0e56fc9660e9"
    sha256 cellar: :any_skip_relocation, catalina:       "79e052470a98a55adbef9426e77ca1a04f4d1af1ed88528e7cae7e3d814ba75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94080f818df52f9bb196e888ad106e68700576e2611b0c2ce28a442138e69fb6"
  end

  on_linux do
    depends_on "libbsd"
  end

  def install
    inreplace "Makefile", "${PREFIX}/include/bsd", "#{Formula["libbsd"].opt_include}/bsd"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "echo foo | xpipe -b 1 -J % /bin/sh -c 'cat >%'"
    assert_predicate testpath/"1", :exist?
    assert_predicate testpath/"2", :exist?
    assert_predicate testpath/"3", :exist?
  end
end
