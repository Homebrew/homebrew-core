class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.4/shared-mime-info-2.4.tar.bz2"
  sha256 "32dc32ae39ff1c1bf8434dd3b36770b48538a1772bc0298509d034f057005992"
  license "GPL-2.0-only"
  revision 1
  head "https://gitlab.freedesktop.org/xdg/shared-mime-info.git", branch: "master"

  livecheck do
    url "https://gitlab.freedesktop.org/api/v4/projects/1205/releases"
    regex(/^(?:Release[._-])?v?(\d+(?:[.-]\d+)+)$/i)
    strategy :json do |json, regex|
      json.map { |item| item["tag_name"]&.[](regex, 1)&.tr("-", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fa674742c5c404fb7265f93a797e483c3ddec4a405180c467d73ffa3a4c2ad86"
    sha256 cellar: :any, arm64_sequoia: "e67c7e8b3bb8386eaebdcaae85eae6a93b8ff0c0f5a710f80c114885edd8d784"
    sha256 cellar: :any, arm64_sonoma:  "a3364bac447af0df2a587c1383b846f425fecd8ce465d804ddfda36ddb64dd94"
    sha256 cellar: :any, sonoma:        "b5060956f4a630be979756cd6a331c223d6537951ee60d925f5e756ad15a1cdb"
    sha256               arm64_linux:   "a1d39e8208f92717cee852ccc2f2fede36477a6e35bad0c95d2473989c789262"
    sha256               x86_64_linux:  "fa1730cfb12535854fbbefeadec508fc4d066b8284b17ed3e89be9405ab8ddc2"
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
