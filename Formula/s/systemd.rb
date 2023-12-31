class Systemd < Formula
  desc "System and service manager"
  homepage "https://wiki.freedesktop.org/www/Software/systemd/"
  url "https://github.com/systemd/systemd-stable/archive/refs/tags/v255.2.tar.gz"
  sha256 "ba7354a742dc9a8bb7dbeaa40cbf7cf2ca84f506d5b7ae5ab8d14c8eecb7aca0"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/systemd/systemd.git", branch: "main"

  bottle do
    sha256 x86_64_linux: "89d33b0f0ea54853f3c39c65088fe00248cb9fa53db5809b3b17936299207e09"
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
  depends_on "python-lxml" => :build
  depends_on "python@3.12" => :build
  depends_on "rsync" => :build
  depends_on "expat"
  depends_on "glib"
  depends_on "libcap"
  depends_on "libxcrypt"
  depends_on :linux
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "util-linux" # for libmount
  depends_on "xz"
  depends_on "zstd"

  resource "docbook" do
    url "https://downloads.sourceforge.net/docbook/docbook-xsl/1.79.1/docbook-xsl-1.79.1.tar.bz2"
    sha256 "725f452e12b296956e8bfb876ccece71eeecdd14b94f667f3ed9091761a4a968"
  end

  resource "oasis-open-4.2" do
    url "https://www.oasis-open.org/docbook/xml/4.2/docbook-xml-4.2.zip"
    sha256 "acc4601e4f97a196076b7e64b368d9248b07c7abf26b34a02cca40eeebe60fa2"
  end

  resource "oasis-open-4.5" do
    url "https://www.oasis-open.org/docbook/xml/4.5/docbook-xml-4.5.zip"
    sha256 "4e4e037a2b83c98c6c94818390d4bdd3f6e10f6ec62dd79188594e26190dc7b4"
  end

  def install
    ENV["PYTHONPATH"] = Formula["jinja2-cli"].opt_libexec/Language::Python.site_packages("python3.12")
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/systemd"

    args = %W[
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
      -Dp11kit=false
      -Dman=true
    ]

    %w[docbook oasis-open-4.2 oasis-open-4.5].each do |r|
      resource(r).stage "man/#{r}"
    end

    inreplace "man/custom-man.xsl", "http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl",
              "docbook/manpages/docbook.xsl"
    inreplace Dir["man/*.xml"] do |f|
      f.gsub! "http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd", "oasis-open-4.2/docbookx.dtd", false
      f.gsub! "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd", "oasis-open-4.5/docbookx.dtd", false
    end

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "temporary: /tmp", shell_output("#{bin}/systemd-path")
  end
end
