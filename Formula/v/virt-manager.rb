class VirtManager < Formula
  include Language::Python::Virtualenv

  desc "App for managing virtual machines"
  homepage "https://virt-manager.org/"
  url "https://releases.pagure.org/virt-manager/virt-manager-4.1.0.tar.gz"
  sha256 "950681d7b32dc61669278ad94ef31da33109bf6fcf0426ed82dfd7379aa590a2"
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/virt-manager/virt-manager.git", branch: "main"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaf4c46bc1c840f14004355b82f0b55105e443f6dd7fa04e853b911758c621f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6197f8319ad569eb3b3e165a069c111e2e26f3b9a609470e5ed7819648c46870"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f8013875f83f7f43c770b735c1fd63516d6f961ddf571fb178b156862005bf1"
    sha256 cellar: :any_skip_relocation, ventura:        "5e043c848d97233b688f2bd71bbc39554803712f66afb2f73b573cf2c73c52da"
    sha256 cellar: :any_skip_relocation, monterey:       "cb36e93827672834f252726220cd275e4a5f5bc07e57775b9743ac0cb298597a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e74a69f4a3de1277655fe2e1902fc45db4882c6abd71a732a572b3ad68b9f62"
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
  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "spice-gtk"
  depends_on "vte3"

  # Resources are for Python `libvirt-python` and `requests` packages

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "libvirt-python" do
    url "https://files.pythonhosted.org/packages/bb/1a/d1cf7c8b988cfbbfcc3d6fb1e4e2216690ff64453d3488c9c9e1dfa1e8e2/libvirt-python-9.6.0.tar.gz"
    sha256 "53422d8e3110139655c3d9c2ff2602b238f8a39b7bf61a92a620119b45550a99"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  # requests require "urllib3>=1.21.1,<3"
  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  def install
    python = "python3.11"
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
