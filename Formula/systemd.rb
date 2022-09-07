class Systemd < Formula
  desc "System and service manager"
  homepage "https://wiki.freedesktop.org/www/Software/systemd/"
  url "https://github.com/systemd/systemd/archive/v251.tar.gz"
  sha256 "0ecc8bb28d3062c8e58a64699a9b16534554bb6a01efb8d5507c893db39f8d51"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1
  head "https://github.com/systemd/systemd.git", branch: "main"

  bottle do
    sha256 x86_64_linux: "96f4b17b8519f82398df5faf793f2e08cc794b4227f91d2ba8eb59c50b07945e"
  end

  depends_on "coreutils" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gperf" => :build
  depends_on "intltool" => :build
  depends_on "jinja2-cli" => :build
  depends_on "libgpg-error" => :build
  depends_on "libtool" => :build
  depends_on "libxslt" => :build
  depends_on "m4" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "rsync" => :build
  depends_on "expat"
  depends_on "libcap"
  depends_on :linux
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "util-linux" # for libmount
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "libxcrypt"

  def install
    ENV["PYTHONPATH"] = Formula["jinja2-cli"].opt_libexec/Language::Python.site_packages("python3.10")
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/systemd"

    args = *std_meson_args + %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      -Drootprefix=#{prefix}
      -Dsysvinit-path=#{etc}/init.d
      -Dsysvrcnd-path=#{etc}/rc.d
      -Dpamconfdir=#{etc}/pam.d
      -Dcreate-log-dirs=false
      -Dhwdb=false
      -Dlz4=true
      -Dgcrypt=false
    ]

    system "meson", "setup", *args, "build"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "temporary: /tmp", shell_output("#{bin}/systemd-path")
  end
end
