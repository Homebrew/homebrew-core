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
    sha256 cellar: :any, arm64_ventura:  "b226ccddc5d7ba7ffb72647709317397f55d48e5f2a39e4d6098b58ca86f17c9"
    sha256 cellar: :any, arm64_monterey: "04faa47b6e83a513a9950ddcc12199419ee54957fccc02b20957c72e9c74ed25"
    sha256 cellar: :any, arm64_big_sur:  "66dfcc869f7c0c7ea914fed11ea4e8b18ac803cb19b015d3eee703784178ea01"
    sha256 cellar: :any, ventura:        "9be7f58b136cc51e10bd9b19006b5268248f08499c1dace3a0211f46eede243d"
    sha256 cellar: :any, monterey:       "49d81141325f0c7d4258cdd9e0edfa8048ba822cd17a96163ee579ffbddac454"
    sha256 cellar: :any, big_sur:        "a200846995764562d1e1363bd5fe5047d373dd6fcb392398f602200075ad14bc"
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
    url "https://files.pythonhosted.org/packages/38/15/eb5fdcca34fd4d9515f216ee9d87db97ca5ab6794ed7e62b1bdaa21316bd/libvirt-python-9.2.0.tar.gz"
    sha256 "95cc190c57cb84e8ed2e1b8205b01a937e1a4bc19cc8865df19ca4470e6d7c1b"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
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
