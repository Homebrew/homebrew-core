class Unibilium < Formula
  desc "Very basic terminfo library"
  homepage "https://github.com/neovim/unibilium"
  url "https://github.com/neovim/unibilium/archive/v2.1.1.tar.gz"
  sha256 "6f0ee21c8605340cfbb458cbd195b4d074e6d16dd0c0e12f2627ca773f3cabf1"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "62e3649d689c32c0d3042436395bf2bcd8d316c30d22d2f9dc666d9776968f51"
    sha256 cellar: :any,                 arm64_ventura:  "27a0c608e5bb1926436855ea5e9c6b1154ff001237aaee905faa1fef9f943396"
    sha256 cellar: :any,                 arm64_monterey: "b4172b327c9ab41032fecb648eedac18e867add559b3cc7951b15f10ae6cd0e1"
    sha256 cellar: :any,                 sonoma:         "0ffc646d060f5e39096f7c3869530b412ad104c21c91fbec057561e9ff1d5112"
    sha256 cellar: :any,                 ventura:        "3f0176e90ac411b252263a1ce8cc2a765bdaabee52af58df33cd5af6bc4dd933"
    sha256 cellar: :any,                 monterey:       "62654f38ea347e7d00e1339dbf6e495d38822fe7484661546ac7fa009d621ac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b83976c8990c0f8a2be32686b8b5ed284184065aea16e4a3c304842d78da7b26"
  end

  depends_on "libtool" => :build

  def install
    # Check Homebrew ncurses terminfo if available.
    terminfo_dirs = [Formula["ncurses"].opt_share/"terminfo"]

    terminfo_dirs += if OS.mac?
      if MacOS.version == :sonoma
        # There is a bug in ncurses5.4-config in the 14.0 SDK (FB13204756)
        # We know what it should output, so enforce it.
        ["/usr/share/terminfo"]
      else
        [Utils.safe_popen_read("ncurses5.4-config", "--terminfo-dirs").strip]
      end
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
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lunibilium", "-o", "test"
    assert_match %r{\A#{Formula["ncurses"].opt_share}/terminfo:}o, shell_output("./test")
  end
end
