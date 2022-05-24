class Wdiff < Formula
  desc "Display word differences between text files"
  homepage "https://www.gnu.org/software/wdiff/"
  url "https://ftp.gnu.org/gnu/wdiff/wdiff-1.2.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/wdiff/wdiff-1.2.2.tar.gz"
  sha256 "34ff698c870c87e6e47a838eeaaae729fa73349139fc8db12211d2a22b78af6b"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_monterey: "b7349e744630b6db059c3d1ee542404eafab86aeb97382fca5e3a746d008ee73"
    sha256 arm64_big_sur:  "b9464ee06d7329a996f8546ee21a90847b3db438967f241d4c9adc8708ef6a21"
    sha256 monterey:       "6d3edf52d29a1bf269e7238effb3a1941a4e6de214df8fe7ad536a69097f072d"
    sha256 big_sur:        "154c6f2169ae3406c43ef7373271499c15cb1954111dfa950ae809f2677ec9de"
    sha256 catalina:       "cd316e673c68a54b9be013a7a0fb96beba13648bd0048f7f1fd8b7a8b07ab821"
    sha256 mojave:         "89e0de3859b91c4dcdc4a9ac2ae4569f72cd472658e6d3dfa82e6acc919c68a1"
    sha256 high_sierra:    "579a8972310d39ac2e660f3114fc6d1536df7ad9f7659a9b00619cc7c50a2191"
    sha256 sierra:         "fcfe6296c4b9879895a4977274f56474faa84ca74c792866ea3149a2f02df553"
    sha256 x86_64_linux:   "f627f458d7e201ad95a07bfc91fbd1aa0e676e695d8002415a02f4b74734e1a4"
  end

  depends_on "gettext"

  uses_from_macos "texinfo" => :build
  uses_from_macos "ncurses"

  conflicts_with "montage", because: "both install an `mdiff` executable"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-experimental"
    system "make", "install"
  end

  test do
    a = testpath/"a.txt"
    a.write "The missing package manager for OS X"

    b = testpath/"b.txt"
    b.write "The package manager for OS X"

    output = shell_output("#{bin}/wdiff #{a} #{b}", 1)
    assert_equal "The [-missing-] package manager for OS X", output
  end
end
