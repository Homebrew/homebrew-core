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
    rebuild 2
    sha256 cellar: :any, arm64_sequoia: "7feb34ce6afb650a39b05fd0dfd75225b659123ae42ce571076eaf2d640c8232"
    sha256 cellar: :any, arm64_sonoma:  "a8235d09d748ebe4c84a0aebdb57c33cd030334050bc9bf4efd57a5f732780d8"
    sha256 cellar: :any, arm64_ventura: "887f26165f0917b9ff0e72f0fe15facb37402df8209d98433358d631a482e7ec"
    sha256 cellar: :any, sonoma:        "6ac3353108a294266ac4769c90c06f28f73ad1bee527869fbb5a96414ffe136f"
    sha256 cellar: :any, ventura:       "a58ae3ada921d8b224fd9c0c0ca992ea6c71cfadb99c1d87dd21a94aa26580c7"
    sha256               arm64_linux:   "8785de2e5e75756fba7ad4d6c686ed6cdc43047124f7f63c373cdd5a131853c4"
    sha256               x86_64_linux:  "d657dadf099a3aea5f7fbdb74310d7f973f551ac62555a8f5699cd6a02642ce7"
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
