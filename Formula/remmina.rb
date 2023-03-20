class Remmina < Formula
  desc "Remote desktop software client for POSIX-based operating systems"
  homepage "https://remmina.org/"
  url "https://gitlab.com/Remmina/Remmina/-/archive/v1.4.30/Remmina-v1.4.30.tar.bz2"
  sha256 "b16d4eb4de4665f8f4d561e1d856d2b2e212c3ec9c652cd70827f2bba12f412a"
  license "GPL-2.0-only"

  depends_on "cmake" => :build
  depends_on "freerdp"
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libsecret"
  depends_on "libssh"
  depends_on "libvncserver"
  depends_on "openssl@3"
  depends_on "python@3.11"
  depends_on "spice-gtk"
  depends_on "vte3"

  on_linux do
    depends_on "webkitgtk"
  end

  def install
    cmake_defs = ["-DHAVE_LIBAPPINDICATOR=OFF"]
    cmake_defs << "-DWITH_WEBKIT2GTK=OFF" unless OS.linux?
    system "cmake", "-S", ".", "-B", "build", *cmake_defs, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/remmina", "--version"
    %w[exec python_wrapper rdp secret spice vnc].each do |plugin|
      system "test", "-s", "#{lib}/remmina/plugins/remmina-plugin-#{plugin}.so"
    end
  end
end
