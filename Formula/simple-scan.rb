class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/44/simple-scan-44.0.tar.xz"
  sha256 "39b870fd46f447f747eaecc2df26049ef773185099f0e13c675656264dd98e95"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "ee3a3064079b059bd94d4192ae570cdbd69a9afc4170f96a0d79c06a05242a58"
    sha256 arm64_monterey: "03cb79c0d57b59ee137039d945f06205bab8c1fb4d59d23a4b370cacf3354b69"
    sha256 arm64_big_sur:  "2149639d70234943efafcf317b3b62d69db43ec2f481b44f6a407455f1bf3d68"
    sha256 ventura:        "28e873b997239eda0a4eb2b5507ecbcf061cf8e332550a435f8460d1da6e188c"
    sha256 monterey:       "cd801aeae0fdde16834189cf91378006e9c79e2c5bd74aacfb37ce24159b153a"
    sha256 big_sur:        "63637752cefd64e78b6b0142056f1db280bb6854911471304c804cf1484a8b0b"
    sha256 x86_64_linux:   "2df6eb455d83446edd9602cd61ee8649e97f5a1830a03d5b45bc5fd24dfc7ae3"
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libgusb"
  depends_on "libhandy"
  depends_on "sane-backends"
  depends_on "webp"

  def install
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # Errors with `Cannot open display`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system "#{bin}/simple-scan", "-v"
  end
end
