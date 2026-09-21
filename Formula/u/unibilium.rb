class Unibilium < Formula
  desc "Very basic terminfo library"
  homepage "https://github.com/neovim/unibilium"
  url "https://github.com/neovim/unibilium/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "7360907bcf79ba49f6fc4a504767ff86e93ab9018477026fcc70d5ab77e1f2c1"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "955d75f75ed264c4efafbbe4b4598825070db0cae8f2a87808c95d9fb44ae2ab"
    sha256 cellar: :any, arm64_tahoe:       "236da70149748828b1b4835aceb4800717b8ec79d8f4735d0c0991b0f2a2c996"
    sha256 cellar: :any, arm64_sequoia:     "3eb5e89e95400ba3546eda862f14d5c7b71f9aa63996eb83e23968bd111a6dc5"
    sha256 cellar: :any, arm64_sonoma:      "d58e6facf47d969962812663c6d0efb3af56a9e468382d9686097ebc8fd8ee59"
    sha256 cellar: :any, arm64_linux:       "2770c02f95dc68f371de67e1bde2a1f64b0887af616eabf05ca9bc1f60eba0cd"
    sha256 cellar: :any, x86_64_linux:      "0ac1d23859dbfc477b05b2a619f02503f378df3bc00b0882c010a7078e23bf30"
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
