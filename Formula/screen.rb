class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen"

  stable do
    url "https://ftp.gnu.org/gnu/screen/screen-4.6.1.tar.gz"
    mirror "https://ftpmirror.gnu.org/screen/screen-4.6.1.tar.gz"
    sha256 "aba9af66cb626155d6abce4703f45cce0e30a5114a368bd6387c966cbbbb7c64"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch :p2 do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha256 "9c53320cbe3a24c8fb5d77cf701c47918b3fabe8d6f339a00cfdb59e11af0ad5"
    end
  end

  bottle do
    sha256 "4af8be279c67c5b325212ec4ca25d97e568daab722d8a086a3089e308aaf69a8" => :sierra
    sha256 "a5f9851b1960061243dcadc6567fb1fc43d1135e101401097b4a2cdf1e7301db" => :el_capitan
    sha256 "9da28814bd7d52c1196e64868f02845a8e6c0ed48bd9d38250271ab985392932" => :yosemite
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
