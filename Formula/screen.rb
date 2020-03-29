class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen"

  stable do
    url "https://ftp.gnu.org/gnu/screen/screen-4.8.0.tar.gz"
    mirror "https://ftpmirror.gnu.org/screen/screen-4.8.0.tar.gz"
    sha256 "6e11b13d8489925fde25dfb0935bf6ed71f9eb47eff233a181e078fde5655aa1"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch :p2 do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha256 "9c53320cbe3a24c8fb5d77cf701c47918b3fabe8d6f339a00cfdb59e11af0ad5"
    end
  end

  bottle do
    sha256 "f3787a0e1c889106ab14d89c4f1bed001716ce1eb79e44e56b20e71b7448e172" => :catalina
    sha256 "30dfe7b1bc6c74d64be57224852e50ebd5d4c6d4939872eaceac5f06d9935208" => :mojave
    sha256 "1e63b4fd4ae798111980a7d9ed47c3fcb867cbad2c4253164b55722efc65d53e" => :high_sierra
  end

  head do
    url "https://git.savannah.gnu.org/git/screen.git"

    # This patch avoid a bug that prevents detached sessions to reattach
    # See https://lists.gnu.org/archive/html/screen-users/2016-10/msg00007.html
    patch do
      url "https://gist.githubusercontent.com/sobrinho/5a7672e088868c2d036957dbe7825dd0/raw/c6fe5dc20cb7dbd0e23f9053aa3867fcbc01d983/diff.patch"
      sha256 "47892633ccb137316a0532b034d0be81edc26fc72a6babca9761a1649bc67fd1"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "ncurses"

  def install
    cd "src" if build.head?

    # With parallel build, it fails
    # because of trying to compile files which depend osdef.h
    # before osdef.sh script generates it.
    ENV.deparallelize

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-colors256",
                          "--enable-pam"

    system "make"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/screen -h", 1)
  end
end
