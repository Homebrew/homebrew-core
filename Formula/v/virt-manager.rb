class VirtManager < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "App for managing virtual machines"
  homepage "https://virt-manager.org/"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/virt-manager/virt-manager.git", branch: "main"

  stable do
    url "https://releases.pagure.org/virt-manager/virt-manager-5.1.0.tar.xz"
    sha256 "ccfc44b6c1c0be8398beb687c675d9ea4ca1c721dfb67bd639209a7b0dec11b1"

    # Backport support for etree rather than deprecated libxml2 python bindings
    # Ref: https://github.com/virt-manager/virt-manager/pull/983
    patch do
      url "https://github.com/virt-manager/virt-manager/commit/d4988b02efb8bba91fd55614fbbff11b3a915d44.patch?full_index=1"
      sha256 "fc1daaf8440b01600b0297384f5bdd1cda654aaee958ce3fcd27d79c6b2d9ffb"
    end
    patch do
      url "https://github.com/virt-manager/virt-manager/commit/ff9fa95e52f890ccd8dce18567aa7cc30582ca4f.patch?full_index=1"
      sha256 "5ae4ce21b65cf77fa9511bae70799bd3c1890ab15a31372491662a7dc186df4f"
    end
    patch do
      url "https://github.com/virt-manager/virt-manager/commit/d0372e82c8b6fe6b5517d850a81847422c861446.patch?full_index=1"
      sha256 "5084650b38527f8bac3f2ea803b81f1a49ecf51cb461c3ad7088ec9f90845dae"
    end
    patch do
      url "https://github.com/virt-manager/virt-manager/commit/766bf2ecdc5ac6853b41a36412d09c1950c700bf.patch?full_index=1"
      sha256 "24deb9287b86caaac7eaea7d5dff145c0686bbc32ccb6952a8a0d4b0c6d3adeb"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a3e60113fb3ef59278da6a46c6676d71717c231c102b34fc4ea820be6e5367e"
  end

  depends_on "docutils" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "adwaita-icon-theme"
  depends_on "certifi" => :no_linkage
  depends_on "cpio"
  depends_on "gtk-vnc"
  depends_on "gtksourceview4"
  depends_on "libosinfo"
  depends_on "libvirt-glib"
  depends_on "libvirt-python" => :no_linkage
  depends_on :macos
  depends_on "osinfo-db"
  depends_on "py3cairo" => :no_linkage
  depends_on "pygobject3" => :no_linkage
  depends_on "python@3.14"
  depends_on "spice-gtk"
  depends_on "vte3"

  pypi_packages package_name:     "",
                exclude_packages: "certifi",
                extra_packages:   "requests"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    python3 = "python3.14"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"

    system "meson", "setup", "build", "-Dtests=disabled",
                                      "-Dupdate-icon-cache=false",
                                      "-Dcompile-schemas=false",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children
  end

  def post_install
    # manual schema compile step
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    # manual icon cache update step
    system Formula["gtk+3"].opt_bin/"gtk3-update-icon-cache", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    libvirt_pid = spawn Formula["libvirt"].opt_sbin/"libvirtd", "-f", Formula["libvirt"].etc/"libvirt/libvirtd.conf"

    output = testpath/"virt-manager.log"
    virt_manager_pid = fork do
      $stdout.reopen(output)
      $stderr.reopen(output)
      exec bin/"virt-manager", "-c", "test:///default", "--debug"
    end
    sleep 20
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    assert_match "conn=test:///default changed to state=Active", output.read
  ensure
    Process.kill("TERM", libvirt_pid)
    Process.kill("TERM", virt_manager_pid)
    Process.wait(libvirt_pid)
    Process.wait(virt_manager_pid)
  end
end
