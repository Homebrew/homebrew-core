class Systemd < Formula
  include Language::Python::Virtualenv

  desc "System and service manager"
  homepage "https://systemd.io"
  url "https://github.com/systemd/systemd/archive/refs/tags/v257.9.tar.gz"
  sha256 "b27dcc100a738b4b5b81f7c5174c1239a6495f5bdf3d3caa94a17b8373e6a1ca"
  license all_of: [
    # Main license is LGPL-2.1-or-later while systemd-udevd is GPL-2.0-or-later
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    # The remaining licenses encompass various exceptions as defined using
    # file-specific SPDX-License-Identifier. Note that we exclude:
    # 1. "BSD-3-Clause" - it is for an unused build script (gen_autosuspend_rules.py)
    # 2. "OFL-1.1" - we do not install HTML documentation
    "CC0-1.0",
    "LGPL-2.0-or-later",
    "MIT",
    "MIT-0",
    :public_domain,
    { "LGPL-2.0-or-later" => { with: "Linux-syscall-note" } },
    { "GPL-1.0-or-later" => { with: "Linux-syscall-note" } },
    { "GPL-2.0-or-later" => { with: "Linux-syscall-note" } },
    { "GPL-2.0-only" => { with: "Linux-syscall-note" } },
    { any_of: ["BSD-3-Clause", "GPL-2.0-only" => { with: "Linux-syscall-note" }] },
    { any_of: ["MIT", "GPL-2.0-only" => { with: "Linux-syscall-note" }] },
    { any_of: ["MIT", "GPL-2.0-or-later" => { with: "Linux-syscall-note" }] },
    { any_of: ["GPL-2.0-only", "BSD-2-Clause"] },
  ]
  head "https://github.com/systemd/systemd.git", branch: "main"

  bottle do
    sha256 arm64_linux:  "38a80d78bd58c8a7954600bcc2b957658f0a7602a18c0828dc8c1c313da5353b"
    sha256 x86_64_linux: "efc8d926ff33038f4527dabb2ba2aaf2d80a5cd5cd910525c38cdea28bef2b5e"
  end

  keg_only "it will shadow system systemd if linked"

  depends_on "coreutils" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gperf" => :build
  depends_on "icu4c@77" => :build # FIXME: brew should add to PKG_CONFIG_PATH as dependency of libxml2
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
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
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/8f/bd/f9d01fd4132d81c6f43ab01983caea69ec9614b913c290a26738431a015d/lxml-6.0.1.tar.gz"
    sha256 "2b3a882ebf27dd026df3801a87cf49ff791336e0f94b0fad195db77e01240690"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", "python3.13")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/systemd"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = %W[
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      -Dsysvinit-path=#{etc}/init.d
      -Dsysvrcnd-path=#{etc}/rc.d
      -Drc-local=#{etc}/rc.local
      -Dpamconfdir=#{etc}/pam.d
      -Dbashcompletiondir=#{bash_completion}
      -Dmode=release
      -Dsshconfdir=no
      -Dsshdconfdir=no
      -Dcreate-log-dirs=false
      -Dhwdb=false
      -Dtests=false
      -Dlz4=enabled
      -Dman=enabled
      -Dacl=disabled
      -Dgcrypt=disabled
      -Dgnutls=disabled
      -Dlibcurl=disabled
      -Dmicrohttpd=disabled
      -Dp11kit=disabled
      -Dpam=disabled
      -Dshellprofiledir=no
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match %r{temporary: (/var)?/tmp}, shell_output(bin/"systemd-path")
  end
end
