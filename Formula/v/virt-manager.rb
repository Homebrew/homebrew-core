class VirtManager < Formula
  include Language::Python::Virtualenv
  include Language::Python::Shebang

  desc "App for managing virtual machines"
  homepage "https://virt-manager.org/"
  license "GPL-2.0-or-later"
  revision 6
  head "https://github.com/virt-manager/virt-manager.git", branch: "main"

  stable do
    url "https://github.com/virt-manager/virt-manager/releases/download/v5.1.0/virt-manager-5.1.0.tar.xz"
    sha256 "ccfc44b6c1c0be8398beb687c675d9ea4ca1c721dfb67bd639209a7b0dec11b1"

    # Backport support for etree rather than deprecated libxml2 python bindings
    # Ref: https://github.com/virt-manager/virt-manager/pull/983
    patch do
      url "https://github.com/virt-manager/virt-manager/commit/d4988b02efb8bba91fd55614fbbff11b3a915d44.patch?full_index=1"
      sha256 "fc1daaf8440b01600b0297384f5bdd1cda654aaee958ce3fcd27d79c6b2d9ffb"
      type :backport
      resolves "https://github.com/virt-manager/virt-manager/issues/897"
    end
    patch do
      url "https://github.com/virt-manager/virt-manager/commit/ff9fa95e52f890ccd8dce18567aa7cc30582ca4f.patch?full_index=1"
      sha256 "5ae4ce21b65cf77fa9511bae70799bd3c1890ab15a31372491662a7dc186df4f"
      type :backport
      resolves "https://github.com/virt-manager/virt-manager/issues/897"
    end
    patch do
      url "https://github.com/virt-manager/virt-manager/commit/d0372e82c8b6fe6b5517d850a81847422c861446.patch?full_index=1"
      sha256 "5084650b38527f8bac3f2ea803b81f1a49ecf51cb461c3ad7088ec9f90845dae"
      type :backport
      resolves "https://github.com/virt-manager/virt-manager/issues/897"
    end
    patch do
      url "https://github.com/virt-manager/virt-manager/commit/766bf2ecdc5ac6853b41a36412d09c1950c700bf.patch?full_index=1"
      sha256 "24deb9287b86caaac7eaea7d5dff145c0686bbc32ccb6952a8a0d4b0c6d3adeb"
      type :backport
      resolves "https://github.com/virt-manager/virt-manager/issues/897"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "652774da2005b93011d2df76ed403c650913a1ecc11af917f3605801f397fbc3"
  end

  depends_on "docutils" => :build
  depends_on "gettext" => :build
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
  depends_on "osinfo-db"
  depends_on "py3cairo" => :no_linkage
  depends_on "pygobject3" => :no_linkage
  depends_on "python@3.15"
  depends_on "spice-gtk"
  depends_on "vte3"

  pypi_packages package_name:     "",
                exclude_packages: "certifi",
                extra_packages:   "requests"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  def install
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

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
  end

  test do
    # The GUI cannot start inside brew's macOS test sandbox, so check its entry point and the `virtinst` tools
    assert_match version.to_s, shell_output("#{bin}/virt-manager --version")

    output = shell_output("#{bin}/virt-install --connect test:///default --name brewtest --memory 64 " \
                          "--disk none --import --osinfo detect=on,require=off --print-xml")
    assert_match "<name>brewtest</name>", output
  end
end
