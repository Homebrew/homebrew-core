class Unibilium < Formula
  desc "Very basic terminfo library"
  homepage "https://github.com/neovim/unibilium"
  url "https://github.com/neovim/unibilium/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "370ecb07fbbc20d91d1b350c55f1c806b06bf86797e164081ccc977fc9b3af7a"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4e4de62f7bd54a11da5b031f9c831040eef3790b9e111f40332feaea4cdd682"
    sha256 cellar: :any,                 arm64_sequoia: "c154ef3c2f532ebb1e73372a76230d144057983813624abbad7ca85d1ce3a2b8"
    sha256 cellar: :any,                 arm64_sonoma:  "dbd59e13386ef0e756eac19424e54c8b3d30ae65eb4c7c7f7d102a290fd409f7"
    sha256 cellar: :any,                 arm64_ventura: "db2c6a451a395ff30ceff7e6dbfd30f7b02343bf08e850ae9d0e20d6c9da42b1"
    sha256 cellar: :any,                 sonoma:        "19a58769977601b8bbc47959efeefb4bad5cc938d7dcde0c083c8227d8296026"
    sha256 cellar: :any,                 ventura:       "0fc063e7d4d00b0b93b8b71c5d57921afad9d09d21ddb044e4e6cc44cecfe9ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "239e6447b0d84b67599683cea8cadae7f8dd273e51426f819603f635577a4dc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62bf69d2c9fe15ec8c9fe12e690befc1d8971c05b7f3f2fb890e2f4740e88798"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args

    # Check Homebrew ncurses terminfo if available.
    terminfo_dirs = [Formula["ncurses"].opt_share/"terminfo"]

    terminfo_dirs += if OS.mac?
      [Utils.safe_popen_read("ncurses5.4-config", "--terminfo-dirs").strip]
    else
      # Unibilium's default terminfo path
      %w[
        /etc/terminfo
        /lib/terminfo
        /usr/share/terminfo
        /usr/lib/terminfo
        /usr/local/share/terminfo
        /usr/local/lib/terminfo
      ]
    end

    system "make", "TERMINFO_DIRS=\"#{terminfo_dirs.join(":")}\""
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <unibilium.h>
      #include <stdio.h>

      int main()
      {
        setvbuf(stdout, NULL, _IOLBF, 0);
        unibi_term *ut = unibi_dummy();
        unibi_destroy(ut);
        printf("%s", unibi_terminfo_dirs);
        return 0;
      }
    C
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lunibilium", "-o", "test"
    assert_match %r{\A#{Formula["ncurses"].opt_share}/terminfo:}o, shell_output("./test")
  end
end
