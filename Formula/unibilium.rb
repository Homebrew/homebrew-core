class Unibilium < Formula
  desc "Very basic terminfo library"
  homepage "https://github.com/neovim/unibilium"
  url "https://github.com/neovim/unibilium/archive/v2.1.1.tar.gz"
  sha256 "6f0ee21c8605340cfbb458cbd195b4d074e6d16dd0c0e12f2627ca773f3cabf1"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "a09c64419c3bfd241682b2b866845c47e14fb34f2ec4c00432a0ffd94552088b"
    sha256 cellar: :any,                 arm64_monterey: "61e46223a65d53ff12dbae623c31b6bf6cf5814e3ef378172a76e157f11a8327"
    sha256 cellar: :any,                 arm64_big_sur:  "949ec76abe1f8f7c3804028793133d68036734b326ee9d30db2132fbc02e7f4e"
    sha256 cellar: :any,                 ventura:        "f7105a9bffd1de736ef229c6079bd2d535516ebb9bf7a6b3efb7332423c2925e"
    sha256 cellar: :any,                 monterey:       "4293a007fa231e58f31aa1fee7cd1f08ab901678c80adbea2e4efaa49d7cb3ca"
    sha256 cellar: :any,                 big_sur:        "d437072bceb93b39d6231dc1132f10284c7033690e2e8fe85193670157c680a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "713531ec3ccf93b6f4ae8e5d5efadf15a2c985176a2086b5607d33598e4de45d"
  end

  depends_on "libtool" => :build

  def install
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
