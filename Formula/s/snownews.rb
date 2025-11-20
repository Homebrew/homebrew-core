class Snownews < Formula
  desc "Text mode RSS newsreader"
  homepage "https://sourceforge.net/projects/snownews/"
  url "https://downloads.sourceforge.net/project/snownews/snownews-1.11.tar.gz"
  sha256 "afd4db7c770f461a49e78bc36e97711f3066097b485319227e313ba253902467"
  license "GPL-3.0-only"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "fc57fbf60e598146c28686c404f621a386c955ae63a8a5ed0d7376d73ce62076"
    sha256 arm64_sequoia: "64dca2fb95dc41e989ce85e01ff04562a72d47e1d9ea8836efb8086775fa0fd5"
    sha256 arm64_sonoma:  "4db952a31225cf2dc4af72c3fdd0b2d72c8f38498cffea6099d1b446d3d4028a"
    sha256 sonoma:        "5cde70ddd3826d0074e625cb2178bb745ae627a5c4562d9e78b10bc8beb1333f"
    sha256 arm64_linux:   "f2329c5bd004312a4074b6320072d607045db64766e3393645222b4d92193924"
    sha256 x86_64_linux:  "65c5beec4e63d9ff40dcb175d0b1afa3d8a994d0519d389bb2f090d03cd5afdc"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "ncurses"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    ENV.deparallelize # due to `install: mkdir /usr/local/Cellar/snownews/1.11_2/share: File exists`
    system "make", "install", "CC=#{ENV.cc}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snownews --help")
  end
end
