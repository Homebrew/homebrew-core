class Zile < Formula
  desc "Text editor development kit"
  homepage "https://www.gnu.org/software/zile/"
  # Before bumping to a new version, check the NEWS file to make sure it is a
  # stable release: https://git.savannah.gnu.org/cgit/zile.git/plain/NEWS
  # For context, see: https://github.com/Homebrew/homebrew-core/issues/67379
  url "https://ftp.gnu.org/gnu/zile/zile-2.6.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/zile/zile-2.6.1.tar.gz"
  sha256 "bfbacddf768e39173a27467924fe409990a3e97be3632a02979865fbb9af0277"
  license "GPL-3.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2e077bc929d8ad6f54297ca6fa9f8d0e32b2166c619376faa871a93409ae7231"
    sha256 cellar: :any, big_sur:       "ddc19628311876015e1bd06b3c4caece27ab8ac3422f5cf0b01dd64bc5260049"
    sha256 cellar: :any, catalina:      "1d684c5d64bc4e3d01a5f6accc8fc6b74f2f703eefb06a41668a2e3a2c27be56"
    sha256 cellar: :any, mojave:        "bf159c4da03f13e6db8cfba823b774495489bfa15480ecaa3428c4cd4909b468"
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "glib"
  depends_on "libgee"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zile --version")
  end
end
