class Zile < Formula
  desc "Text editor development kit"
  homepage "https://www.gnu.org/software/zile/"
  url "https://ftp.gnu.org/gnu/zile/zile-2.6.0.90.tar.gz"
  mirror "https://ftpmirror.gnu.org/zile/zile-2.6.0.90.tar.gz"
  sha256 "239b5b9575e3310205912cb87a25a6bff0d951feb7623722041ee2aa95e50dae"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "48c52dde41ef2db567df0f2365ff327fa6aa3fd76ad993f61bb628ea7c7eb4b6" => :big_sur
    sha256 "688531ff5ae6927488cdb44cc6186a912a488e0af1f0873ab7cb510b1b421c94" => :catalina
    sha256 "fdab12bef4a723b51d471ed258b993e4ec7d5ab5655bbd4a25c896f32b86ee79" => :mojave
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
