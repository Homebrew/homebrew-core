class VirtManager < Formula
  include Language::Python::Virtualenv

  desc "App for managing virtual machines"
  homepage "https://virt-manager.org/"
  url "https://releases.pagure.org/virt-manager/virt-manager-4.1.0.tar.gz"
  sha256 "950681d7b32dc61669278ad94ef31da33109bf6fcf0426ed82dfd7379aa590a2"
  license "GPL-2.0-or-later"
  revision 6
  head "https://github.com/virt-manager/virt-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "14429d8f3fb234cb4de3b000f034b6b10acfca45a3b8a15cbdbf9f46d78a69e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6783700ef6e932b444508bfec50d88609d640c4cb2232c7eb8d5cfac5642ec1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c5474b471b67c8dca81234745cd79144df4744a7cfdc5a8b4988fe9d869cab9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b26211b260ec8a8d0eb5888bf5e9311a75761ba3e840bf7c6abcd3e461e9d88"
    sha256 cellar: :any_skip_relocation, ventura:        "bf51feb81223c6e96bcd88df41f9aa8543fe094062306c63b14f188cc5f64f19"
    sha256 cellar: :any_skip_relocation, monterey:       "65a24cd05348fc76c900ce7b989dcf8280274c14b7203958674a50ad70efa1fa"
  end

  depends_on "docutils" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "adwaita-icon-theme"
  depends_on "certifi"
  depends_on "cpio"
  depends_on "gtk-vnc"
  depends_on "gtksourceview4"
  depends_on "libosinfo"
  depends_on "libvirt-glib"
  depends_on "libvirt-python"
  depends_on "libxml2" # can't use from macos, since we need python3 bindings
  depends_on :macos
  depends_on "osinfo-db"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.12"
  depends_on "spice-gtk"
  depends_on "vte3"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/86/ec/535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392db/requests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    # Restore disabled egg_info command
    inreplace "setup.py", "'install_egg_info': my_egg_info,", ""
    system libexec/"bin/python", "setup.py", "configure", "--prefix=#{prefix}"
    ENV["PIP_CONFIG_SETTINGS"] = "--global-option=--no-update-icon-cache --no-compile-schemas"
    venv.pip_install_and_link buildpath

    prefix.install libexec/"share"
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
