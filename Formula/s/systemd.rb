class Systemd < Formula
  include Language::Python::Virtualenv

  desc "System and service manager"
  homepage "https://systemd.io"
  url "https://github.com/systemd/systemd/archive/refs/tags/v262.1.tar.gz"
  sha256 "100fc873b848b9b0297d8a705e8e2ed326256c8483d9960ee1ffe264c8a5c3e3"
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
  compatibility_version 1
  head "https://github.com/systemd/systemd.git", branch: "main"

  bottle do
    sha256 arm64_linux:  "5c187152e90c68875a9f0e8c94bf5217e5b1248ab75ce240892da47169b10f46"
    sha256 x86_64_linux: "6dbe8142459c75b274dacd657d01b2760443eb5e41918a36881942be5eebedb3"
  end

  keg_only "it will shadow system systemd if linked"

  depends_on "coreutils" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gperf" => :build
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => :build
  depends_on "libxcrypt"
  depends_on :linux
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "util-linux" # for libmount
  depends_on "xz"
  depends_on "zstd"

  pypi_packages package_name:   "",
                extra_packages: %w[jinja2 lxml]

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/systemd"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = %W[
      --localstatedir=#{var}
      --sysconfdir=#{etc}
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

    # D-Bus dirs default to the read-only dbus keg via pkg-config; use our own prefix
    args += %W[
      -Ddbuspolicydir=#{share}/dbus-1/system.d
      -Ddbussessionservicedir=#{share}/dbus-1/services
      -Ddbussystemservicedir=#{share}/dbus-1/system-services
      -Ddbus-interfaces-dir=#{share}/dbus-1/interfaces
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match %r{temporary: (/var)?/tmp}, shell_output(bin/"systemd-path")
  end
end
