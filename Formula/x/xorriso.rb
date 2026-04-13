class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "https://ftpmirror.gnu.org/gnu/xorriso/xorriso-1.5.8.pl01.tar.gz"
  mirror "https://ftp.gnu.org/gnu/xorriso/xorriso-1.5.8.pl01.tar.gz"
  version "1.5.8.pl01"
  sha256 "0381798b7bb4f162578b4f31fe30bfe53608b5077075967f8df2facfab4c90f9"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?xorriso[._-]v?(\d+(?:\.\d+)+(?:\.pl\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ae6596253b19bf4732b7c8a74f20535ab8b46414690df40c5a9319de540c604"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1817ac4183438f776342fbee5c693304bd38d1a01eabd3d147186ca9b6c46ea3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18fdd5844714ba4e72b7be697a95a429516c520baa1b16e48852c874ef0287ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa314d914a9a3cfe05b0fecdfa6d243b3f8781799428f2e54deba68a517221a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4b09addf2c831337eea4fb7a200b5b1ebb28d05d1078f7b6c44f84f1327b051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cdad49ea388995ff54cd1923eb72d02ed73b6fbeb8cbfb237544680ef4ed2f7"
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
