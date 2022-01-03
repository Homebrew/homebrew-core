class Systemd < Formula
  desc "System and service manager"
  homepage "https://wiki.freedesktop.org/www/Software/systemd/"
  url "https://github.com/systemd/systemd/archive/v250.tar.gz"
  sha256 "389935dea020caf6e2e81a4e90e556bd5599a2086861045efdc06197776e94e1"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/systemd/systemd.git", branch: "main"

  bottle do
    sha256 x86_64_linux: "d528e99c79c4206c87137c8968d0b6691e30c6c4ec335c9630f449688fb50351"
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

  patch do
    url "https://github.com/SMillerDev/systemd/commit/fb945d00b98b9f63d48cceca7da92f183dd369c1.patch?full_index=1"
    sha256 "3422c3f8404350ca09de5e5ab03440053e4dd8be0c7919345cab3993c0a41dd4"
  end

  def install
    ENV["PYTHONPATH"] = Formula["jinja2-cli"].opt_libexec/Language::Python.site_packages("python3")

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
