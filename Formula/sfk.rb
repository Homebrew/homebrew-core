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
    sha256 "488668e8facb4c96ef56bb43a9a89c8dbd02e832625be5f0bb6a50cbf087ac42" => :sierra
    sha256 "4bb2ac089b26993d8fd7f6118cf15805945d141977152db4b696d543d526ae3f" => :el_capitan
    sha256 "93ac8468fd3211682b1bb92bc28fcad631a22beeeb58f1ec86a2d7816b57932a" => :yosemite
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
