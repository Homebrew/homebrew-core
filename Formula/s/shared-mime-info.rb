class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.4/shared-mime-info-2.4.tar.bz2"
  sha256 "32dc32ae39ff1c1bf8434dd3b36770b48538a1772bc0298509d034f057005992"
  license "GPL-2.0-only"
  revision 1
  compatibility_version 1
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
    sha256 cellar: :any, arm64_tahoe:   "5411356847e0e209c1ae3622200b3a8ad25dd4b3d7ccc760b69d24f3e414ef08"
    sha256 cellar: :any, arm64_sequoia: "8dfd77c8baca230f856f57d5c5ffd518c5c147234cb2fb150389909fb0b05acf"
    sha256 cellar: :any, arm64_sonoma:  "c2c4802af57990d5629237264955223bce6f504a3baab475396d0b66c5621c57"
    sha256 cellar: :any, sonoma:        "ecf64a0a5743b0726c449ede6e36d9043693ecd5e104d981049d912f00e3edfb"
    sha256               arm64_linux:   "3397d58c69d02e9cfdca3c01faebe5312c0c6ae45d374444eb2c61f42c9e8c7a"
    sha256               x86_64_linux:  "ceafdff20dab55cbcb38a71cecf82e71fd1c41b3dbdfb2f6c621f9f85d152354"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "glib"

  uses_from_macos "libxml2"

  # This used to be copied rather than symlinked
  link_overwrite "share/mime/packages/freedesktop.org.xml"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    update_mime_database
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath

    cp_r share/"mime", testpath
    system bin/"update-mime-database", testpath/"mime"
  end
end
