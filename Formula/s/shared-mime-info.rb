class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.5.1/shared-mime-info-2.5.1.tar.bz2"
  sha256 "b75b420da9b0be9a3d99b1bee6ed87957b56ab54583ac1a97fbd0dc98ddddb25"
  license "GPL-2.0-only"
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
    sha256 cellar: :any, arm64_tahoe:   "175d0d795dfbb1874181f80b2c113d07477e3adcde031bbf4d7dc4eafe9932a7"
    sha256 cellar: :any, arm64_sequoia: "eb86118daf14319d85ea1cd9e63c240bad0f7d595154a2b2e2c68c362f02ecad"
    sha256 cellar: :any, arm64_sonoma:  "3d6ca31a073c7dffc0a85df9caf464d5ba1be7761688dbb51bffe4a4236e44cd"
    sha256 cellar: :any, sonoma:        "c7951cc3967666ed9197cf8c5415cfd0846844b67d9c9daa061142b06f4af668"
    sha256               arm64_linux:   "9d05cc9cf16ef36f272d845e159d9064d8045aaad2b4dfd8d76311d008037a0b"
    sha256               x86_64_linux:  "0c437c9eff86b2dec2f79752de0690c1f037584bbcd008a888a845507edfa09f"
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

    system "meson", "setup", "build", "-Dbuild-tests=false", *std_meson_args
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
