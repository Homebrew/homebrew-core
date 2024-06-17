class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.4/shared-mime-info-2.4.tar.bz2"
  sha256 "32dc32ae39ff1c1bf8434dd3b36770b48538a1772bc0298509d034f057005992"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/xdg/shared-mime-info.git", branch: "master"

  livecheck do
    url "https://gitlab.freedesktop.org/api/v4/projects/1205/releases"
    regex(/shared-mime-info v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "7ae03513d2d3a6fa26507d7ad9c83f8d45918cb8702c945bcee1c0c468577768"
    sha256 cellar: :any, arm64_ventura:  "a72325b3fd197cf31399ef2604a1ae3baf93e4a144ad548c7464608117a8dfab"
    sha256 cellar: :any, arm64_monterey: "0c4211d8572f33a5c3c7f3c1b7cc57a6e9f5599456269fcd31a7da9ed7b20f66"
    sha256 cellar: :any, sonoma:         "cbaf7565626aac827d36135bb5c7a034d36f76577a4a77aaa78bfc89e508c0bf"
    sha256 cellar: :any, ventura:        "555377ce54f93784fb32582161278fbb16228571cbdfb87ae7857ff8424ec267"
    sha256 cellar: :any, monterey:       "eb9240c54296df715bd7f77ca11a86200d49accdc449d5fd1b00e752029924ea"
    sha256               x86_64_linux:   "714303fdaefab5a012a1aa3d37243c02b1b4ff9bcd8347058165e903c4972840"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "glib"

  uses_from_macos "libxml2"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    # Disable the post-install update-mimedb due to crash
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install share/"mime/packages"
    rmdir share/"mime"
  end

  def post_install
    global_mime = HOMEBREW_PREFIX/"share/mime"
    cellar_mime = share/"mime"

    # Remove bad links created by old libheif postinstall
    rm_rf global_mime if global_mime.symlink?

    if !cellar_mime.exist? || !cellar_mime.symlink?
      rm_rf cellar_mime
      ln_sf global_mime, cellar_mime
    end

    (global_mime/"packages").mkpath
    cp (pkgshare/"packages").children, global_mime/"packages"

    system bin/"update-mime-database", global_mime
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath

    cp_r share/"mime", testpath
    system bin/"update-mime-database", testpath/"mime"
  end
end
