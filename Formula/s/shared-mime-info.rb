class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.4/shared-mime-info-2.4.tar.bz2"
  sha256 "32dc32ae39ff1c1bf8434dd3b36770b48538a1772bc0298509d034f057005992"
  license "GPL-2.0-only"
  head "https://gitlab.freedesktop.org/xdg/shared-mime-info.git", branch: "master"

  livecheck do
    url "https://gitlab.freedesktop.org/api/v4/projects/1205/releases"
    regex(/^(?:Release[._-])?v?(\d+(?:[.-]\d+)+)$/i)
    strategy :json do |json, regex|
      json.map { |item| item["tag_name"]&.[](regex, 1)&.tr("-", ".") }
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia:  "ad25e39cd436c77aa33f7d72259a8fbaf64ae326c483872fbce4e7cc70861bee"
    sha256 cellar: :any, arm64_sonoma:   "8bc2cab1abadcf5e1cae58ed5e7790836ca77bdffca2e822b166d1f0428f2043"
    sha256 cellar: :any, arm64_ventura:  "f93ab2e3969c2f220aeacbaebeb207e69dc7017ad482a0245800e4284edecf60"
    sha256 cellar: :any, arm64_monterey: "2a333234f3aeea4068ce80b4a2a9eef000efe8171ab8e0ae3c9ec47b9c048979"
    sha256 cellar: :any, sonoma:         "5b1d636b97cee712556c0b4254323d348e88539aa2624ab26fd4f628b123bd9b"
    sha256 cellar: :any, ventura:        "a3d0d249beec0cdd7aec131d420fbb8c91aca2a1cf56ae279c70c5111dcb51f8"
    sha256 cellar: :any, monterey:       "91e6622c3a864359424f0177e558dfbc9f1e0704de17f57dec0391d85f64cf12"
    sha256               x86_64_linux:   "561ecaae8e76fd5fd2a7fbf23c1a6a55d9f9139896441f65b2eef09e6ace60e4"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
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
    rm_r(share/"mime") if (share/"mime").exist?
  end

  def post_install
    global_mime = HOMEBREW_PREFIX/"share/mime"
    cellar_mime = share/"mime"

    # Remove bad links created by old libheif postinstall
    rm_r(global_mime) if global_mime.symlink?

    rm_r(cellar_mime) if cellar_mime.exist? && !cellar_mime.symlink?
    ln_sf(global_mime, cellar_mime)

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
