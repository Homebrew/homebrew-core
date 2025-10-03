class Termrec < Formula
  desc "Record videos of terminal output"
  homepage "https://angband.pl/termrec.html"
  url "https://github.com/kilobyte/termrec/archive/refs/tags/v0.19.tar.gz"
  sha256 "0550c12266ac524a8afb764890c420c917270b0a876013592f608ed786ca91dc"
  license "LGPL-3.0-or-later"
  head "https://github.com/kilobyte/termrec.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "0abe8cc3df72b187ea7c2aa19c180e0ef4404ff91560cd1b4bbc7e20884bdd85"
    sha256 cellar: :any,                 arm64_sequoia: "e49f5031c0c2bd9c8a17c75bd3d345755a47525ef4a68d32ca257dcb47b7eb10"
    sha256 cellar: :any,                 arm64_sonoma:  "206c6ea13f36cb770ad80f1702f1620a5a8cd8a82eea1e01d136f6b46ccecf03"
    sha256 cellar: :any,                 arm64_ventura: "b5e160a090054b7e36883023816a7123f6305131c9248cb2543d939d209a7c7b"
    sha256 cellar: :any,                 sonoma:        "8225f9ddc5ff3c7e8110435fdfd09d5e0310a4370dcded0e1b4a4ef06424f9c7"
    sha256 cellar: :any,                 ventura:       "d58a44779c299757776b50043dd4a039fdccc99d96d77a4ada9096499adbfe01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3958a773f4a5f6981ed0d7bd45594a982d7db69b77badac66615edee697f84ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5d5fbe66e009d9a482ea968920e75bf9789fcbc1b08fa7d865ab90528709a11"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    # Work around build error: call to undeclared function 'forkpty'
    # Issue ref: https://github.com/kilobyte/termrec/issues/8
    ENV.append "CFLAGS", "-include util.h" if DevelopmentTools.clang_build_version >= 1403

    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"termrec", "--help"
  end
end
