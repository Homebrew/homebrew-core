class S3ql < Formula
  include Language::Python::Virtualenv

  desc "POSIX-compliant FUSE filesystem using object store as block storage"
  homepage "https://github.com/s3ql/s3ql"
  # TODO: Try to remove `cython` and corresponding build_cython in the next release.
  # check if `python3 setup.py build_cython` is still needed in https://github.com/s3ql/s3ql/blob/master/.github/workflows/pr-ci.yml#L34
  url "https://github.com/s3ql/s3ql/releases/download/s3ql-5.2.3/s3ql-5.2.3.tar.gz"
  sha256 "892acf8a479fc837256100d820408bc5e2c27c0ba9ee2b5f8aa114d593b5af87"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "96328863e3da5545903385b786971fc1b8bbd0be4151dbd5bd738c979f6a57b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ff2f720afc9d4216f721454f97a5f4fe133ee503b0d3167d3f2012a33ae84a4d"
  end

  depends_on "cython" => :build
  depends_on "pkgconf" => :build

  depends_on "cryptography"
  depends_on "libffi"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "apsw" do
    url "https://files.pythonhosted.org/packages/2e/9f/29be0326b2178cfe10d6d45de83163c70cd0b4985502f398fe32791943e2/apsw-3.46.1.0.tar.gz"
    sha256 "96e3dfad1fd0cc77a778aa6b27468292041a8e9cb1f2dcf06bd773762c9b0c0c"
  end

  resource "async-generator" do
    url "https://files.pythonhosted.org/packages/ce/b6/6fa6b3b598a03cba5e80f829e0dadbb49d7645f523d209b2fb7ea0bbb02a/async_generator-1.10.tar.gz"
    sha256 "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "dugong" do
    url "https://files.pythonhosted.org/packages/10/90/2110a0201f34bd12ac75e67ddffb67b14f3de2732474e89cbb04123c4b16/dugong-3.8.2.tar.gz"
    sha256 "f46ab34d74207445f268e3d9537a72e648c2c81a74e40d5d0e32306d24ff81bb"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/a1/37/c854a8b1b1020cf042db3d67577c6f84cd1e8ff6515e4f5498ae9e444ea5/google_auth-2.35.0.tar.gz"
    sha256 "f4c64ed4e01e8e8b646ef34c018f8bf3338df0c8e37d8b3bba40e7f574a3278a"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/cc/0f/1772edb8d75ecf6280f1c7f51cbcebe274e8b17878b382f63738fd96cee5/google_auth_oauthlib-1.2.1.tar.gz"
    sha256 "afd0cad092a2eaa53cd8e8298557d6de1034c6cb4a740500b5357b648af97263"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "outcome" do
    url "https://files.pythonhosted.org/packages/98/df/77698abfac98571e65ffeb0c1fba8ffd692ab8458d617a0eed7d9a8d38f2/outcome-1.3.0.post0.tar.gz"
    sha256 "9dcf02e65f2971b80047b377468e72a268e15c0af3cf1238e6ff14f7f91143b8"
  end

  resource "pyfuse3" do
    url "https://files.pythonhosted.org/packages/67/1e/0f8f285a65e2e64f2f0c4accce4ee67d9ac66ee9684492a4327e48d68d87/pyfuse3-3.4.0.tar.gz"
    sha256 "793493f4d5e2b3bc10e13b3421d426a6e2e3365264c24376a50b8cbc69762d39"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/8d/e6/2fc95aec377988ff3ca882aa58d4f6ab35ff59a12b1611a9fe3075eb3019/setuptools-70.2.0.tar.gz"
    sha256 "bd63e505105011b25c3c11f753f7e3b8465ea739efddaccef8f0efac2137bac1"
  end

  resource "trio" do
    url "https://files.pythonhosted.org/packages/9a/03/ab0e9509be0c6465e2773768ec25ee0cb8053c0b91471ab3854bbf2294b2/trio-0.26.2.tar.gz"
    sha256 "0346c3852c15e5c7d40ea15972c4805689ef2cb8b5206f794c9c19450119f3a4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    python3 = "python3.13"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    # The inreplace changes the name of the (fsck|mkfs|mount|umount).s3ql
    # utilities to use underscore (_) as a separator, which is consistent
    # with other tools on macOS.
    # Final names: fsck_s3ql, mkfs_s3ql, mount_s3ql, umount_s3ql
    inreplace "setup.py", /'(?:(mkfs|fsck|mount|umount)\.)s3ql =/, "'\\1_s3ql ="

    # Regenerate Cython files for Python 3.13 support. Try to remove in next release.
    ENV.prepend_path "PYTHONPATH", Formula["cython"].opt_libexec/Language::Python.site_packages(python3)
    system libexec/"bin/python3", "setup.py", "build_cython"

    system libexec/"bin/python3", "setup.py", "build_ext", "--inplace"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "S3QL ", shell_output(bin/"mount_s3ql --version")

    # create a local filesystem, and run an fsck on it
    assert_match "Creating metadata", shell_output(bin/"mkfs_s3ql --plain local://#{testpath} 2>&1")
    assert_match "s3ql_params", shell_output("ls s3ql_params")
    system bin/"fsck_s3ql", "local://#{testpath}"
  end
end
