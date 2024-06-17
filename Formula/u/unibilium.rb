class Unibilium < Formula
  desc "Very basic terminfo library"
  homepage "https://github.com/neovim/unibilium"
  url "https://github.com/neovim/unibilium/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "6f0ee21c8605340cfbb458cbd195b4d074e6d16dd0c0e12f2627ca773f3cabf1"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "fe23eecccadee9f6dd9c28cab31fde6f708428b4b381080f65eb639a9757836b"
    sha256 cellar: :any,                 arm64_ventura:  "d9089f06243f3f86c73d4480e6fc7aa0bfdfc59d359c190601f8c9f13b4e38f7"
    sha256 cellar: :any,                 arm64_monterey: "2d241d597c1db3b4431147b57fdfc943f60b3ecc876808501514c5f06f544228"
    sha256 cellar: :any,                 sonoma:         "ea8a5e33c52996bc397a2b15e525c73ac9af26e7f7611ebe045fec9f61b569d5"
    sha256 cellar: :any,                 ventura:        "31ed55e023b40282074973529a224d94d195a885dbac72ff912c5ff2c5398eee"
    sha256 cellar: :any,                 monterey:       "1fa9505ecff50e96b7da87f20e8e7a195e5a8619236d41759061eccd1947d015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00566865c6a2a0fde041269e20fc1afe0f239720fa588016843e5409bf0e909d"
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
