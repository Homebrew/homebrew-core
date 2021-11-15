class Systemd < Formula
  desc "System and service manager"
  homepage "https://wiki.freedesktop.org/www/Software/systemd/"
  url "https://github.com/systemd/systemd/archive/v246.tar.gz"
  sha256 "4268bd88037806c61c5cd1c78d869f7f20bf7e7368c63916d47b5d1c3411bd6f"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/systemd/systemd.git", branch: "main"

  bottle do
    rebuild 2
    sha256 x86_64_linux: "e9a110ca3890c88a257831d4ed305a995ece7cebdbb3994cb376ecc521e445ee"
  end

  depends_on "coreutils" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gperf" => :build
  depends_on "intltool" => :build
  depends_on "libgpg-error" => :build
  depends_on "libtool" => :build
  depends_on "libxslt" => :build
  depends_on "m4" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "rsync" => :build
  depends_on "expat"
  depends_on "libcap"
  depends_on :linux
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "util-linux" # for libmount
  depends_on "xz"
  depends_on "zstd"

  # Fix newer meson compatibility, remove after next release
  patch do
    url "https://github.com/systemd/systemd/commit/c29537f39e4f413a6cbfe9669fa121bdd6d8b36f.patch?full_index=1"
    sha256 "fc7f07d3f4710a6b798a3976f51bd375f4051495246ae519e887146a13dc6130"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --libdir=lib
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      -Drootprefix=#{prefix}
      -Dsysvinit-path=#{prefix}/etc/init.d
      -Dsysvrcnd-path=#{prefix}/etc/rc.d
      -Dpamconfdir=#{prefix}/etc/pam.d
      -Dcreate-log-dirs=false
      -Dhwdb=false
      -Dlz4=true
      -Dgcrypt=false
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    assert_match "temporary: /tmp", shell_output("#{bin}/systemd-path")
  end
end
