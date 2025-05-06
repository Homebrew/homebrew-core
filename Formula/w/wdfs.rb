class Wdfs < Formula
  desc "Webdav file system"
  homepage "http://noedler.de/projekte/wdfs/"
  url "http://noedler.de/projekte/wdfs/wdfs-1.4.2.tar.gz"
  sha256 "fcf2e1584568b07c7f3683a983a9be26fae6534b8109e09167e5dff9114ba2e5"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d5bef8c1e794e7fb184f7a04210de8a0e1d4e409ef20317d091abc2e6d4db08b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8e9e8b67d2d470f355a46983ac2a52cb2c34a6ebd63e1720e5ceb010c7bd9298"
  end

  # Also needs `libfuse@2` and had 0 installs in 90 days on deprecation date
  deprecate! date: "2025-03-06", because: :unmaintained

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "neon"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"wdfs", "-v"
  end
end
