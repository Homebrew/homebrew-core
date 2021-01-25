class Zile < Formula
  desc "Text editor development kit"
  homepage "https://www.gnu.org/software/zile/"
  # Before bumping to a new version, check the NEWS file to make sure it is a
  # stable release: https://git.savannah.gnu.org/cgit/zile.git/plain/NEWS
  # For context, see: https://github.com/Homebrew/homebrew-core/issues/67379
  url "https://ftp.gnu.org/gnu/zile/zile-2.4.15.tar.gz"
  mirror "https://ftpmirror.gnu.org/zile/zile-2.4.15.tar.gz"
  sha256 "39c300a34f78c37ba67793cf74685935a15568e14237a3a66fda8fcf40e3035e"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "45c8f93c5e1d937a6f945343db7615c4fc1fe4d287b1b5777a9578234a2ef645" => :big_sur
    sha256 "ed302040d0b263f1de4344e0826afe53462001af631becf80e8e6c5d97058719" => :arm64_big_sur
    sha256 "49fb51f48ad1526f27c94f357653f0f2503a5bca98c6550378468ea513b32aed" => :catalina
    sha256 "161f09a4b1f56d85b644b994bbf0a7449e710b30dee08db4ab88e4e3db501c59" => :mojave
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
