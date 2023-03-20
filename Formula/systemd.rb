class Systemd < Formula
  desc "System and service manager"
  homepage "https://wiki.freedesktop.org/www/Software/systemd/"
  url "https://github.com/systemd/systemd/archive/v253.tar.gz"
  sha256 "acbd86d42ebc2b443722cb469ad215a140f504689c7a9133ecf91b235275a491"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/systemd/systemd.git", branch: "main"

  bottle do
    sha256 x86_64_linux: "7013a6313b536193abf0205457a7f063e83af6bc11290b395323760ac1fcb5e5"
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
  depends_on "python@3.11" => :build
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
    ENV["PYTHONPATH"] = Formula["jinja2-cli"].opt_libexec/Language::Python.site_packages("python3.11")
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/systemd"

    args = std_meson_args + %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      -Drootprefix=#{prefix}
      -Dsysvinit-path=#{etc}/init.d
      -Dsysvrcnd-path=#{etc}/rc.d
      -Dpamconfdir=#{etc}/pam.d
      -Dbashcompletiondir=#{bash_completion}
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
