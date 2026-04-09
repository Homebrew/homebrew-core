class VirtManager < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "App for managing virtual machines"
  homepage "https://virt-manager.org/"
  license "GPL-2.0-or-later"
  revision 4
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
    sha256 cellar: :any_skip_relocation, all: "ba009f03c1945f3b90b71e84593025ea7f61386e5a7af90e215bc3e0ce55bdbd"
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
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/34/64/8860370b167a9721e8956ae116825caff829224fbca0ca6e7bf8ddef8430/requests-2.33.0.tar.gz"
    sha256 "c7ebc5e8b0f21837386ad0e1c8fe8b829fa5f544d8df3b2253bff14ef29d7652"
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
