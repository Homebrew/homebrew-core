# The tarball is not APFS friendly
# "Can't create 'sfk-1.8.8/testfiles/Formats/22-umlauts-???-name.txt'"
# Reported 24 Nov 2017 https://sourceforge.net/p/swissfileknife/bugs/50/
class SfkDownloadStrategy < CurlDownloadStrategy
  def stage
    exclude = "#{name}-#{version}/testfiles/Formats"
    safe_system "tar", "xf", cached_location, "--exclude", exclude
    chdir
  end
end

class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.8.8/sfk-1.8.8.tar.gz",
      :using => SfkDownloadStrategy
  sha256 "b139998e3aca294fe74ad2a6f0527e81cbd11eddfb5e8a81f6067a79d26c97ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "4be767422ed9a90cd6298a6525d3957be2a9de56bd16fa461fc239bdb0878259" => :high_sierra
    sha256 "2861fbe744b3b3dc67ada77dc6d2b200cd4bebdb0b7f9af3933275eec6455c5b" => :sierra
    sha256 "f426a218d0178df2d4615392bf833628d6a0298c7e5038a2b25cb33b86a3e1f2" => :el_capitan
  end

  def install
    ENV.libstdcxx

    # Fix "error: ordered comparison between pointer and zero"
    # Reported 24 Nov 2017 https://sourceforge.net/p/swissfileknife/bugs/51/
    if DevelopmentTools.clang_build_version >= 900
      inreplace "sfk.cpp",
                "if (fgets(szLineBuf, MAX_LINE_LEN, stdin) <= 0)",
                "if (fgets(szLineBuf, MAX_LINE_LEN, stdin) <= (void *)0)"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
