class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/42/simple-scan-42.1.tar.xz"
  sha256 "859bc0611c1769b5bdaba9639deed359f50474c2eecf58bbbfd7ce21911b2226"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "b559290e29cbb134b2ccb68470e7ae982b0fac1a90445c4d429b7b754e07b63e"
    sha256 arm64_big_sur:  "84af3f25baf4d5975a25063b5ddda24c6f7c1afcbae3329cdb66f0a84121aea6"
    sha256 monterey:       "78613570beb02f278ec988af4b3bfca41bf3cb4a66ad4135fe87f20dcd2128e5"
    sha256 big_sur:        "c7c9e4343201e1d86d01dd97396e66c8994fc1972b3faa451358b28cb523c893"
    sha256 catalina:       "6da2e4e16e4f9776bea96c7f26360dabf3383aa23fbee848a77ccbe07cb60597"
    sha256 x86_64_linux:   "c12434254a56faa36fd70d1ce97cd6ed6a43aceae3c1158584200a0aad49963a"
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
