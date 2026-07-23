class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "https://ftpmirror.gnu.org/gnu/xorriso/xorriso-1.5.8.pl02.tar.gz"
  mirror "https://ftp.gnu.org/gnu/xorriso/xorriso-1.5.8.pl02.tar.gz"
  version "1.5.8.pl02"
  sha256 "b1455ecafbf0692ddafe1d71002a96f2ce2d77f4deae602678261ce033f97bc8"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?xorriso[._-]v?(\d+(?:\.\d+)+(?:\.pl\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5741d0c557d215bbed7c7cfa0e27fa783cde03b1e24d1573c307a0474eca4cef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42076b4f0ba09e08ca8a87dc0609b89788661b6e30577022119a934f8dd7197a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "205d1454b924725e38e8b97c3f1fd39803131d592ef337cc4636e650de394351"
    sha256 cellar: :any_skip_relocation, sonoma:        "675972f55695288cee07bf5b5762b306febfabe68d2fcd9730352406ea668400"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3391c3b9f214da3ad9337d05288f0ceb38d6fad8f20f602776fc0b834b20ecba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e16f63be8205b02ac402af686ba9aef3905b01a2ae3e3f7f40e4968d273fdee"
  end

  on_linux do
    depends_on "acl"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"

    # `make install` has to be deparallelized due to the following error:
    #   mkdir: /usr/local/Cellar/xorriso/1.4.2/bin: File exists
    #   make[1]: *** [install-binPROGRAMS] Error 1
    # Reported 14 Jun 2016: https://lists.gnu.org/archive/html/bug-xorriso/2016-06/msg00003.html
    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match "List of xorriso extra features", shell_output("#{bin}/xorriso -list_extras")
    assert_match version.to_s, shell_output("#{bin}/xorriso -version")
  end
end
