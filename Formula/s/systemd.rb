class Systemd < Formula
  include Language::Python::Virtualenv

  desc "System and service manager"
  homepage "https://systemd.io"
  url "https://github.com/systemd/systemd/archive/refs/tags/v256.4.tar.gz"
  sha256 "7861d544190f938cac1b242624d78c96fe2ebbc7b72f86166e88b50451c6fa58"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/systemd/systemd.git", branch: "main"

  bottle do
    sha256 x86_64_linux: "cf512356374d9b79509db4d2e112fb55693a963bcd5908ba3445729d9c882505"
  end

  depends_on "coreutils" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gperf" => :build
  depends_on "libgpg-error" => :build
  depends_on "libtool" => :build
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "m4" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/63/f7/ffbb6d2eb67b80a45b8a0834baa5557a14a5ffce0979439e7cd7f0c4055b/lxml-5.2.2.tar.gz"
    sha256 "bb2dc4898180bea79863d5487e5f9c7c34297414bad54bcd0f0852aee9cfdb87"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

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
    venv = virtualenv_create(buildpath/"venv", "python3.12")
    venv.pip_install resources.select { |r| r.url.start_with?("https://files.pythonhosted.org/") }
    ENV.prepend_path "PATH", venv.root/"bin"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/systemd"

    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      -Dsysvinit-path=#{etc}/init.d
      -Dsysvrcnd-path=#{etc}/rc.d
      -Dpamconfdir=#{etc}/pam.d
      -Dbashcompletiondir=#{bash_completion}
      -Dsshconfdir=no
      -Dsshdconfdir=no
      -Dcreate-log-dirs=false
      -Dhwdb=false
      -Dlz4=enabled
      -Dman=enabled
      -Dgcrypt=disabled
      -Dp11kit=disabled
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
    assert_match "temporary: /tmp", shell_output(bin/"systemd-path")
  end
end
