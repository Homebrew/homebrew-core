class VirtManager < Formula
  include Language::Python::Virtualenv

  desc "App for managing virtual machines"
  homepage "https://virt-manager.org/"
  url "https://virt-manager.org/download/sources/virt-manager/virt-manager-4.1.0.tar.gz"
  sha256 "950681d7b32dc61669278ad94ef31da33109bf6fcf0426ed82dfd7379aa590a2"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/virt-manager/virt-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_monterey: "933cb3be47ad74530134790be879f8ae2d2cd856cf24ef0f945733825cb4cfe2"
    sha256 cellar: :any, arm64_big_sur:  "047d1e006707eca158a33f76640bfac39a0f0050478d5333657663b1e2e79933"
    sha256 cellar: :any, monterey:       "cbbbc39c8a74c4564e5348ce6b4111241f6b8b5c18413060793f5098a9c2f9ee"
    sha256 cellar: :any, big_sur:        "68d7598d629d8d7a51762011d989a85ad6067f3c901d2a64a595f9bdd2576657"
    sha256 cellar: :any, catalina:       "e3fc0aa9c16ae9a1481a0089157262c2d821fe3b5a7f766273faedb65a05398a"
  end

  depends_on "docutils" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cpio"
  depends_on "gtk-vnc"
  depends_on "gtksourceview4"
  depends_on "libosinfo"
  depends_on "libvirt-glib"
  depends_on "libxml2" # can't use from macos, since we need python3 bindings
  depends_on :macos
  depends_on "osinfo-db"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.10"
  depends_on "spice-gtk"
  depends_on "vte3"

  # Resources are for Python `libvirt-python` and `requests` packages

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "libvirt-python" do
    url "https://files.pythonhosted.org/packages/77/64/066990abfec62e6976e5e74a6fc6e8403fcc8b4f6d266deb85a31994f34f/libvirt-python-8.8.0.tar.gz"
    sha256 "3441dd34c8936393e195a1b046bc2cab1b14d35d66772e8a51fe4d9735ec6349"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    python = "python3.10"
    venv = virtualenv_create(libexec, python)
    venv.pip_install resources

    args = Language::Python.setup_install_args(prefix, python)
    args.insert((args.index "install"), "--no-update-icon-cache", "--no-compile-schemas")

    system libexec/"bin/python", "setup.py", "configure", "--prefix=#{prefix}"
    system libexec/"bin/python", *args
  end

  def post_install
    # manual schema compile step
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    # manual icon cache update step
    system Formula["gtk+3"].opt_bin/"gtk3-update-icon-cache", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    libvirt_pid = fork do
      exec Formula["libvirt"].opt_sbin/"libvirtd", "-f", Formula["libvirt"].etc/"libvirt/libvirtd.conf"
    end

    output = testpath/"virt-manager.log"
    virt_manager_pid = fork do
      $stdout.reopen(output)
      $stderr.reopen(output)
      exec bin/"virt-manager", "-c", "test:///default", "--debug"
    end
    sleep 10

    assert_match "conn=test:///default changed to state=Active", output.read
  ensure
    Process.kill("TERM", libvirt_pid)
    Process.kill("TERM", virt_manager_pid)
    Process.wait(libvirt_pid)
    Process.wait(virt_manager_pid)
  end
end
