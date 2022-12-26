class VirtManager < Formula
  include Language::Python::Virtualenv

  desc "App for managing virtual machines"
  homepage "https://virt-manager.org/"
  url "https://virt-manager.org/download/sources/virt-manager/virt-manager-4.1.0.tar.gz"
  sha256 "950681d7b32dc61669278ad94ef31da33109bf6fcf0426ed82dfd7379aa590a2"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/virt-manager/virt-manager.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "93eb5424928236ce254f84db4737117b347d7840d402b141e0d6b005b1dd6454"
    sha256 cellar: :any, arm64_monterey: "c849b4b56579ed58b9173b5afe169c2e36c824f612de88aaa455b1c159af5912"
    sha256 cellar: :any, arm64_big_sur:  "7bb68e96770ce58ddf4b8e573c39eb6c3a3e80ac99b4691552924b985e7a0c54"
    sha256 cellar: :any, ventura:        "7d3cf797e1dc14df47ccdb0c98ed12bbca6813c39794869737066d7393e9ac14"
    sha256 cellar: :any, monterey:       "f9247264bf9ecbc83b23ea2a3628794cde26f5545e2f7c08ecfbd79d561f0005"
    sha256 cellar: :any, big_sur:        "157111370a8a92b2bd00da9d32398756dc2411006627a969510870e0d078c6ca"
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
  depends_on "python@3.11"
  depends_on "spice-gtk"
  depends_on "vte3"

  # Resources are for Python `libvirt-python` and `requests` packages

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
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
    url "https://files.pythonhosted.org/packages/ce/2a/2a41b4818f28fc4e8fca8e33f14ca52db5e35aae295e439ac03ceb6b4765/libvirt-python-8.10.0.tar.gz"
    sha256 "fc30f136abe0b8228029a90814c8f44ac2947433c12f211363051c57df2d5401"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
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
