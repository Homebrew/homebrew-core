class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/42/simple-scan-42.1.tar.xz"
  sha256 "859bc0611c1769b5bdaba9639deed359f50474c2eecf58bbbfd7ce21911b2226"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "b35b5c6ac0f562ffd0726e92c1be604ef9277b7b51edd1a5027fdd6690f7b3f1"
    sha256 arm64_big_sur:  "43b0ffd9979ab5469f8beeacc2d04d15679fd27ec26322916f56d488a6fc4717"
    sha256 monterey:       "e7b802dc36363a1f5c5772515582e938e7ebb74ff24a77871911d7b1263c0475"
    sha256 big_sur:        "290eeb48d96252789d33dae8e2b4295f41d477fd6bf081a78e7e47e8a502d677"
    sha256 catalina:       "18dcb33f6a5cb5110c5f49a6243f0c60362388fe6702e4fd09d42e16b4b02af1"
    sha256 x86_64_linux:   "d77f133de90e9ce36e089adbabc8bee2deceefed635969d723fb079d13ffe814"
  end

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
