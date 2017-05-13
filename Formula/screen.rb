class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen"

  stable do
    url "https://ftp.gnu.org/gnu/screen/screen-4.5.1.tar.gz"
    mirror "https://ftpmirror.gnu.org/screen/screen-4.5.1.tar.gz"
    sha256 "97db2114dd963b016cd4ded34831955dcbe3251e5eee45ac2606e67e9f097b2d"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch :p2 do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha256 "9c53320cbe3a24c8fb5d77cf701c47918b3fabe8d6f339a00cfdb59e11af0ad5"
    end
  end

  bottle do
    sha256 "6c198af919f360fff022ab6c34da174f1e19cd5356c14469fa0df6049162938f" => :sierra
    sha256 "37cf0c9ab5ead029e630867a715b33798e1d394463f2797c709d6924f0116bf2" => :el_capitan
    sha256 "99096efbab0342f633c1e3d35400ebe2a1daa758dd2de03e1ede510d3816ea81" => :yosemite
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
    if build.head?
      cd "src"
    end

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
