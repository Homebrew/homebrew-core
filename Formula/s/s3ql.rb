class S3ql < Formula
  include Language::Python::Virtualenv

  desc "POSIX-compliant FUSE filesystem using object store as block storage"
  homepage "https://github.com/s3ql/s3ql"
  url "https://github.com/s3ql/s3ql/releases/download/s3ql-5.4.0/s3ql-5.4.0.tar.gz"
  sha256 "65f2f8826642c63cc24d6b77eafcc50456e220b3ba9732d4c04266bd41853c20"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "fc74cb6b30bcd49addc69adf8ea433e05ef6e367f0977729e1d25a1dfbd1464a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "816d7470053c783689ee0bd125a9b6a8bafca6488dbce36fba028a4fafbff12b"
  end

  depends_on "pkgconf" => :build

  depends_on "cryptography"
  depends_on "libffi"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "python@3.13"

  resource "apsw" do
    url "https://files.pythonhosted.org/packages/02/ea/7469e89d75a07972255aac4c1b98675bfbc74df32a19dd5dc8ba87aa552b/apsw-3.50.4.0.tar.gz"
    sha256 "a817c387ce2f4030ab7c3064cf21e9957911155f24f226c3ad4938df3a155e11"
  end

  resource "async-generator" do
    url "https://files.pythonhosted.org/packages/ce/b6/6fa6b3b598a03cba5e80f829e0dadbb49d7645f523d209b2fb7ea0bbb02a/async_generator-1.10.tar.gz"
    sha256 "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
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
    url "https://files.pythonhosted.org/packages/9e/9b/e92ef23b84fa10a64ce4831390b7a4c2e53c0132568d99d4ae61d04c8855/google_auth-2.40.3.tar.gz"
    sha256 "500c3a29adedeb36ea9cf24b8d10858e152f2412e3ca37829b3fa18e33d63b77"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/fb/87/e10bf24f7bcffc1421b84d6f9c3377c30ec305d082cd737ddaa6d8f77f7c/google_auth_oauthlib-1.2.2.tar.gz"
    sha256 "11046fb8d3348b296302dd939ace8af0a724042e8029c1b872d87fabc9f41684"
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
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/dc/3976b322de9d2e87ed0007cf04cc7553969b6c7b3f48a565d0333748fbcd/setuptools-80.3.1.tar.gz"
    sha256 "31e2c58dbb67c99c289f51c16d899afedae292b978f8051efaf6262d8212f927"
  end

  resource "trio" do
    url "https://files.pythonhosted.org/packages/01/c1/68d582b4d3a1c1f8118e18042464bb12a7c1b75d64d75111b297687041e3/trio-0.30.0.tar.gz"
    sha256 "0781c857c0c81f8f51e0089929a26b5bb63d57f927728a5586f7e36171f064df"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
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
    # The inreplace changes the name of the (fsck|mkfs|mount|umount).s3ql
    # utilities to use underscore (_) as a separator, which is consistent
    # with other tools on macOS.
    # Final names: fsck_s3ql, mkfs_s3ql, mount_s3ql, umount_s3ql
    inreplace "pyproject.toml", /"(?:(mkfs|fsck|mount|umount)\.)s3ql" =/, '"\\1_s3ql" ='

    virtualenv_install_with_resources
  end

  test do
    assert_match "S3QL ", shell_output("#{bin}/mount_s3ql --version")

    # create a local filesystem, and run an fsck on it
    assert_match "Creating metadata", shell_output("#{bin}/mkfs_s3ql --plain local://#{testpath} 2>&1")
    assert_match "s3ql_params", shell_output("ls s3ql_params")
    system bin/"fsck_s3ql", "local://#{testpath}"
  end
end
