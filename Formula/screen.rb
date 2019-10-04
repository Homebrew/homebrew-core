class Screen < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen"

  stable do
    url "https://ftp.gnu.org/gnu/screen/screen-4.7.0.tar.gz"
    mirror "https://ftpmirror.gnu.org/screen/screen-4.7.0.tar.gz"
    sha256 "da775328fa783bd2a787d722014dbd99c6093effc11f337827604c2efc5d20c1"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch :p2 do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha256 "9c53320cbe3a24c8fb5d77cf701c47918b3fabe8d6f339a00cfdb59e11af0ad5"
    end
  end

  bottle do
    sha256 "ba5b400eb46f44507a473fb6fc749e384cb1d8f1677303135228bfb1a0d9de1b" => :mojave
    sha256 "8f49501b0a53d9160060c05b46c2b120334795a19134ac80a021b298c731e864" => :high_sierra
    sha256 "6c1a701f2166ccb235bbb961b0ce4e526bad87dd1d923c97fb00fc15cb1fc961" => :sierra
    sha256 "f01ac1d6e94e5d5fabef9dd7c458ebe30cad4ecdde37c188e40bb4c5247cdb1d" => :el_capitan
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
