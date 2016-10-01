class Valkyrie < Formula
  desc "GUI for Memcheck and Helgrind tools in Valgrind 3.6.X"
  homepage "http://valgrind.org/downloads/guis.html"
  url "http://valgrind.org/downloads/valkyrie-2.0.0.tar.bz2"
  sha256 "a70b9ffb2409c96c263823212b4be6819154eb858825c9a19aad0ae398d59b43"

  head "svn://svn.valgrind.org/valkyrie/trunk"

  bottle do
    rebuild 1
    sha256 "df2b8f3092c6417bfec6f7e94814a92febc364b6fecb2fa8723946f40827a1c1" => :el_capitan
    sha256 "7992f813d519d4e70a4f1c140e664f5ffa47fea263433a1af2a0368a22754a24" => :yosemite
    sha256 "f06323976b965095fb5bfe1c637ed42d175cdd2b4d1dedde3252788ba61b4bfa" => :mavericks
  end

  depends_on "qt"
  depends_on "valgrind"

  def install
    # Prevents "undeclared identifier" errors for getpid, usleep, and getuid.
    # Reported 21st Apr 2016 to https://bugs.kde.org/show_bug.cgi?id=362033
    inreplace "src/utils/vk_utils.h",
      "#include <iostream>",
      "#include <iostream>\n#include <unistd.h>"

    system "qmake", "PREFIX=#{prefix}"
    system "make", "install"
    prefix.install bin/"valkyrie.app"
  end

  test do
    assert_match version.to_s, shell_output("#{prefix}/valkyrie.app/Contents/MacOS/valkyrie -v 2>/dev/null")
  end
end
