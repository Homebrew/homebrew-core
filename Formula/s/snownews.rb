class Snownews < Formula
  desc "Text mode RSS newsreader"
  homepage "https://sourceforge.net/projects/snownews/"
  url "https://downloads.sourceforge.net/project/snownews/snownews-1.11.tar.gz"
  sha256 "afd4db7c770f461a49e78bc36e97711f3066097b485319227e313ba253902467"
  license "GPL-3.0-only"
  revision 3

  bottle do
    sha256 arm64_golden_gate: "df23d946e3615c38f9dd0611e57c51c6eb7ba61f98ae7c3fc5ec206af4e69aca"
    sha256 arm64_tahoe:       "fd4780e0e097fb0fe14e4b4b23b253e2ec233df3cde2e05d64cb43266977ea1e"
    sha256 arm64_sequoia:     "ebdf9f09a9eedbc6318d7f5e150af3495d70c33956d561175780b682939e0b3d"
    sha256 arm64_linux:       "3edc1a87a4e493c7175fb956476d08b9ec6dca2bd5a0957622bc4e6c1022e27b"
    sha256 x86_64_linux:      "615eb21e24063ea23cc7452df29625662a0b48cedf6afeeddf707959cdffab13"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "ncurses"
  depends_on "openssl@4"

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
