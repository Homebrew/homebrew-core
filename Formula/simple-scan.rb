class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.38/simple-scan-3.38.2.tar.xz"
  sha256 "a88d80729682888649cdfcdfa8692b0a34acde569dc080888f279afc3a9c4d0b"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "4716cff5e9a7afdf63f20dc2603cbf0fd103a4df285ce5caf40dc64dad842c09" => :big_sur
    sha256 "600fdb2b30c0b8749af1fd896142541c4e438d271f5ab0f5766a8b4269337c4d" => :arm64_big_sur
    sha256 "03b95a0e68d590e76186741ff20e569c7d655153565ade06aee89f1f2cf140ae" => :catalina
    sha256 "3ffe9a4c286b228958c210feb818c2b39fe36f1a587adf150005a36a49e002bf" => :mojave
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libgusb"
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
    system "#{bin}/simple-scan", "-v"
  end
end
