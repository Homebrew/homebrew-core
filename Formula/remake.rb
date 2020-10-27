class Remake < Formula
  desc "GNU Make with improved error handling, tracing, and a debugger"
  homepage "https://bashdb.sourceforge.io/remake"
  url "https://downloads.sourceforge.net/project/bashdb/remake/4.3%2Bdbg-1.5/remake-4.3%2Bdbg-1.5.tar.gz"
  version "4.3-1.5"
  sha256 "2e6eb709f3e6b85893f14f15e34b4c9b754aceaef0b92bb6ca3a025f10119d76"
  license "GPL-3.0"

  # We check the "remake" directory page because the bashdb project contains
  # various software and remake releases may be pushed out of the SourceForge
  # RSS feed.
  livecheck do
    url "https://sourceforge.net/projects/bashdb/files/remake/"
    strategy :page_match
    regex(%r{href=.*?remake/v?(\d+(?:\.\d+)+(?:(?:%2Bdbg)?[._-]\d+(?:\.\d+)+)?)/?["' >]}i)
  end

  bottle do
    sha256 "ad7371427c7aa33cc28ac17f8f91fd6dd6a4e15b031a8aedabdc38a8da5ae7f7" => :catalina
    sha256 "308ec13eaf2295d55be5d8dd92e9932a8fa9d25dd06001f43436fcd304b638e3" => :mojave
    sha256 "835577312df4dc23a7ea0701b15b80db4cd233cfaf4efcfbd6bfea8f0f5b27d5" => :high_sierra
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all:
      \techo "Nothing here, move along"
    EOS
    system bin/"remake", "-x"
  end
end
