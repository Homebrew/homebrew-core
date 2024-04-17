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
    rebuild 9
    sha256 cellar: :any, arm64_sonoma:   "41fd6e9a29d3603489ab9da23e8966e1dcaaaecaf66e19ffe47122abdbe850d0"
    sha256 cellar: :any, arm64_ventura:  "f53adafe25e436ef8e61ce865b1af111b8c2de9e4ddf1d0730f1c568c3339919"
    sha256 cellar: :any, arm64_monterey: "e746ef562019ccc97d922eedcd91f93c1bbc9ef0db0e7065c8fef7bc1fbbdf77"
    sha256 cellar: :any, sonoma:         "b7667d575c7a133e03822d83a5b57cb90077c8fbecfd6d79b1a162eef0af3ff0"
    sha256 cellar: :any, ventura:        "fc0ce55d9c07f4c60731b8b2cfcdcf7359b1c4dfccc090e6bca981b9ea956d16"
    sha256 cellar: :any, monterey:       "5c0e2b424eef79822016435dd21a2349b89a5d22f4d59f9c632114d7f57d966a"
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

  resource "libvirt-python" do
    url "https://files.pythonhosted.org/packages/47/f7/5c5112f79761616bf0388b97bb4d0ea1de1d015fb46a40672fe56fdc8ef0/libvirt-python-10.2.0.tar.gz"
    sha256 "483a2e38ffc2e65f743e4c819ccb45135dbe50b594a0a2cd60b73843dcfde694"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
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
