class Zile < Formula
  desc "Text editor development kit"
  homepage "https://www.gnu.org/software/zile/"
  # For version bumps, check the NEWS file in the tarball to make sure that
  # this is a stable release. For context, see
  # https://github.com/Homebrew/homebrew-core/issues/67379
  url "https://ftp.gnu.org/gnu/zile/zile-2.4.15.tar.gz"
  mirror "https://ftpmirror.gnu.org/zile/zile-2.4.15.tar.gz"
  sha256 "39c300a34f78c37ba67793cf74685935a15568e14237a3a66fda8fcf40e3035e"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    skip "Version string does not distinguish stable from beta"
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

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zile --version")
  end
end
