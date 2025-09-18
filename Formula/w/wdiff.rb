class Wdiff < Formula
  desc "Display word differences between text files"
  homepage "https://www.gnu.org/software/wdiff/"
  url "https://ftpmirror.gnu.org/gnu/wdiff/wdiff-1.2.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/wdiff/wdiff-1.2.2.tar.gz"
  sha256 "34ff698c870c87e6e47a838eeaaae729fa73349139fc8db12211d2a22b78af6b"
  license "GPL-3.0-or-later"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "4f7f90aa9ea87d7e897ac17039054345a41bd830322a44ffae5b53dbac412037"
    sha256 arm64_sequoia:  "3080690e641baa84f2f9e6099d27827911ae38604baf1eec25d49f22bf8f0cd8"
    sha256 arm64_sonoma:   "0a0159cb5c9fa9a0d97a14533d8bee020988815ed6c6b8f46650876cded83611"
    sha256 arm64_ventura:  "4e8e8de9f66bdb3734ab9087a59528e2a0f7a27f2b3bd9ab853858c2ee928c41"
    sha256 arm64_monterey: "b7349e744630b6db059c3d1ee542404eafab86aeb97382fca5e3a746d008ee73"
    sha256 arm64_big_sur:  "b9464ee06d7329a996f8546ee21a90847b3db438967f241d4c9adc8708ef6a21"
    sha256 sonoma:         "c89e5767f5622001959dd19ea9ab369622f3674ffed87efcb9b4305014326eab"
    sha256 ventura:        "b1a390b9eedcb428e27b948eb6bb73292570be55125dedf707e53e4732d2a0a6"
    sha256 monterey:       "6d3edf52d29a1bf269e7238effb3a1941a4e6de214df8fe7ad536a69097f072d"
    sha256 big_sur:        "154c6f2169ae3406c43ef7373271499c15cb1954111dfa950ae809f2677ec9de"
    sha256 catalina:       "cd316e673c68a54b9be013a7a0fb96beba13648bd0048f7f1fd8b7a8b07ab821"
    sha256 arm64_linux:    "67a8199b4a46eb788b48cd52e139416a6171a349e9ac50ba76637b436552bcf5"
    sha256 x86_64_linux:   "f627f458d7e201ad95a07bfc91fbd1aa0e676e695d8002415a02f4b74734e1a4"
  end

  depends_on "gettext"

  uses_from_macos "ncurses"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

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
