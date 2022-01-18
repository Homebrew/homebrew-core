class VirtManager < Formula
  include Language::Python::Virtualenv

  desc "App for managing virtual machines"
  homepage "https://virt-manager.org/"
  url "https://releases.pagure.org/virt-manager/virt-manager-3.2.0.tar.gz"
  sha256 "2b6fe3d90d89e1130227e4b05c51e6642d89c839d3ea063e0e29475fd9bf7b86"
  license "GPL-2.0-or-later"
  head "https://github.com/virt-manager/virt-manager.git", branch: "master"

  depends_on "docutils" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build

  depends_on "adwaita-icon-theme"
  depends_on "gtk-vnc"
  depends_on "gtksourceview4"
  depends_on "libosinfo"
  depends_on "libvirt-glib"
  depends_on "libxml2" # can't use from macos, since we need python3 bindings
  depends_on "osinfo-db"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.9"
  depends_on "spice-gtk"
  depends_on "vte3"

  resource "libvirt-python" do
    url "https://libvirt.org/sources/python/libvirt-python-7.10.0.tar.gz"
    sha256 "267774bbdf99d47515274542880499437dc94ae291771f5663c62020a62da975"
  end

  resource "idna" do
    url "https://pypi.io/packages/source/i/idna/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "certifi" do
    url "https://pypi.io/packages/source/c/certifi/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "chardet" do
    url "https://pypi.io/packages/source/c/chardet/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "urllib3" do
    url "https://pypi.io/packages/source/u/urllib3/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "requests" do
    url "https://pypi.io/packages/source/r/requests/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    # virt-manager uses distutils, doesn't like --single-version-externally-managed
    system libexec/"bin/python", "setup.py",
                   "configure",
                   "--prefix=#{libexec}"
    system libexec/"bin/python", "setup.py",
                     "--no-user-cfg",
                     "--no-update-icon-cache",
                     "--no-compile-schemas",
                     "install"

    # install virt-manager commands with PATH set to Python virtualenv environment
    bin.install libexec.glob("bin/virt-*")
    bin.env_script_all_files(libexec/"bin", PATH: "#{libexec}/bin:$PATH")

    share.install libexec/"share/man"
    share.install libexec/"share/glib-2.0"
    share.install libexec/"share/icons"
  end

  def post_install
    # manual schema compile step
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    # manual icon cache update step
    system Formula["gtk+3"].opt_bin/"gtk3-update-icon-cache", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    begin
      pid = fork do
        exec bin/"virt-manager", "-c", "test:///default", "--no-fork"
      end
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
