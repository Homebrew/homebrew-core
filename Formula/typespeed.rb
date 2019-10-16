class Typespeed < Formula
  desc "Zap words flying across the screen by typing them correctly"
  homepage "https://typespeed.sourceforge.io"
  url "https://downloads.sourceforge.net/project/typespeed/typespeed/0.6.5/typespeed-0.6.5.tar.gz"
  sha256 "5c860385ceed8a60f13217cc0192c4c2b4705c3e80f9866f7d72ff306eb72961"

  bottle do
    sha256 "cff9da11f7441f1ff4db7cbfa57f0711ff0bbe08a80ee7067021c619bc01cb06" => :catalina
    sha256 "49c54c15fa8204ca5ae373f0a1995c01b7b6e24de0ab0af7d8081e9f3b229258" => :mojave
    sha256 "70fe987eeaabcf8e94996d56a478c1aac14781f2475337476ff2dc87543bb602" => :high_sierra
    sha256 "8c4af1a3e4e8c32eab5da01fc3b30604eaad86bf84f4a96af7878599c92a4a36" => :sierra
    sha256 "82223614505b9fac677ba4ac4ad9f3b646597cddde604f8c981cc000b8ed7bf6" => :el_capitan
    sha256 "23d3acaedb26f5bedccc2186dec138679fdea40f036edd57ce84ff363c082206" => :yosemite
    sha256 "2dca5154739dc08e5a3ac88acfed5377f7547124cfceb6e4e86e9a1bf2fa531a" => :mavericks
  end

  def install
    # Fix the hardcoded gcc.
    inreplace "src/Makefile.in", "gcc", ENV.cc
    inreplace "testsuite/Makefile.in", "gcc", ENV.cc
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
