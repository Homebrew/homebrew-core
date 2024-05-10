class S3ql < Formula
  include Language::Python::Virtualenv

  desc "POSIX-compliant FUSE filesystem using object store as block storage"
  homepage "https://github.com/s3ql/s3ql"
  # TODO: Try to remove `cython` and corresponding build_cython in the next release.
  # check if `python3 setup.py build_cython` is still needed in https://github.com/s3ql/s3ql/blob/master/.github/workflows/pr-ci.yml#L27
  url "https://github.com/s3ql/s3ql/releases/download/s3ql-5.2.0/s3ql-5.2.0.tar.gz"
  sha256 "150e5f67071af334c98afd123bd95f101d4ba293cf353ae71b34c8e7f90a6155"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "26f9d814bbbd7350ec8c8c5e395be911ed5ad95f72f3e38e8c5ff9e25095c741"
  end

  depends_on "cython" => :build
  depends_on "pkg-config" => :build
  depends_on "cffi"
  depends_on "cryptography"
  depends_on "libffi"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "openssl@3"
  depends_on "python@3.12"
  depends_on "six"

  resource "apsw" do
    url "https://files.pythonhosted.org/packages/c3/e1/2773d8d993eb39d5cbe92f376b5d2454c66e458ebf5e6a110c094d2aa749/apsw-3.45.3.0.tar.gz"
    sha256 "e538e439b1bd0f4e8347db623d50c83f66c662432827a1113bfbad298764fbc5"
  end

  resource "async-generator" do
    url "https://files.pythonhosted.org/packages/ce/b6/6fa6b3b598a03cba5e80f829e0dadbb49d7645f523d209b2fb7ea0bbb02a/async_generator-1.10.tar.gz"
    sha256 "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
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
    url "https://files.pythonhosted.org/packages/18/b2/f14129111cfd61793609643a07ecb03651a71dd65c6974f63b0310ff4b45/google-auth-2.29.0.tar.gz"
    sha256 "672dff332d073227550ffc7457868ac4218d6c500b155fe6cc17d2b13602c360"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/44/77/7433818d44cadd1964473b1d9ab5ecea36e6f951cf2b5188e08f7ebd5dab/google-auth-oauthlib-1.2.0.tar.gz"
    sha256 "292d2d3783349f2b0734a0a0207b1e1e322ac193c2c09d8f7c613fb7cc501ea8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "outcome" do
    url "https://files.pythonhosted.org/packages/98/df/77698abfac98571e65ffeb0c1fba8ffd692ab8458d617a0eed7d9a8d38f2/outcome-1.3.0.post0.tar.gz"
    sha256 "9dcf02e65f2971b80047b377468e72a268e15c0af3cf1238e6ff14f7f91143b8"
  end

  resource "pyfuse3" do
    url "https://files.pythonhosted.org/packages/7c/67/c045eca0938c75c609ba9200f474e3b8b13a5c813e119bf3ab2d1fa37ac4/pyfuse3-3.3.0.tar.gz"
    sha256 "2b31fe412479f9620da2067dd739ed23f4cc37364224891938dedf7766e573bd"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/d6/4f/b10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aed/setuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  resource "trio" do
    url "https://files.pythonhosted.org/packages/b4/51/4f5ae37ec58768b9c30e5bc5b89431a7baf3fa9d0dda98983af6ef55eb47/trio-0.25.0.tar.gz"
    sha256 "9b41f5993ad2c0e5f62d0acca320ec657fdb6b2a2c22b8c7aed6caf154475c4e"
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

    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    # The inreplace changes the name of the (fsck|mkfs|mount|umount).s3ql
    # utilities to use underscore (_) as a separator, which is consistent
    # with other tools on macOS.
    # Final names: fsck_s3ql, mkfs_s3ql, mount_s3ql, umount_s3ql
    inreplace "setup.py", /'(?:(mkfs|fsck|mount|umount)\.)s3ql =/, "'\\1_s3ql ="

    # Regenerate Cython files for Python 3.12 support. Try to remove in next release.
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
