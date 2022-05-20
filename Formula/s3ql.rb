class S3ql < Formula
  include Language::Python::Virtualenv

  desc "POSIX-compliant FUSE filesystem using object store as block storage"
  homepage "https://github.com/s3ql/s3ql"
  url "https://github.com/s3ql/s3ql/releases/download/release-3.8.1/s3ql-3.8.1.tar.gz"
  sha256 "d4731ebaacadca38a677bb18a99446c19d4f5b573628d55371f715acace11c4c"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b8cbd4e1467afc2b01ee93e45bed64baca9a0cd9915b57873e647bcf6927a99a"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  uses_from_macos "libffi"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "rust" => :build
    depends_on "libfuse"
  end

  resource "apsw" do
    url "https://github.com/rogerbinns/apsw/archive/refs/tags/3.38.1-r1.tar.gz"
    sha256 "d7863124c54a6abac04dd48f46b5b910e5718c36a7a21be51fc4a7e03dd45c53"
  end

  resource "async_generator" do
    url "https://files.pythonhosted.org/packages/ce/b6/6fa6b3b598a03cba5e80f829e0dadbb49d7645f523d209b2fb7ea0bbb02a/async_generator-1.10.tar.gz"
    sha256 "6ebb3d106c12920aaae42ccb6f787ef5eefdcdd166ea3d628fa8476abe712144"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/51/05/bb2b681f6a77276fc423d04187c39dafdb65b799c8d87b62ca82659f9ead/cryptography-37.0.2.tar.gz"
    sha256 "f224ad253cc9cea7568f49077007d2263efa57396a2f2f78114066fd54b5c68e"
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
    url "https://files.pythonhosted.org/packages/fd/8c/3c24a436775d6582effe4ecaf33b2562e6a7f0cbc647a293c764c5eac9ee/google-auth-2.6.6.tar.gz"
    sha256 "1ba4938e032b73deb51e59c4656a00e0939cf0b1112575099f136babb4563312"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/14/49/9f23d33e5872446c8162d63f035f222c1d0d74d0fbe00cea9e2538351432/google-auth-oauthlib-0.5.1.tar.gz"
    sha256 "30596b824fc6808fdaca2f048e4998cc40fb4b3599eaea66d28dc7085b36c5b8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "outcome" do
    url "https://files.pythonhosted.org/packages/88/b5/9ccedd89d641dcfa5771f636a8a2e99f9d98b09f511f4f870d382ef2b007/outcome-1.1.0.tar.gz"
    sha256 "e862f01d4e626e63e8f92c38d1f8d5546d3f9cce989263c521b2e7990d186967"
  end

  resource "pyfuse3" do
    url "https://files.pythonhosted.org/packages/2f/99/ceb3f424cfac5011b6749160285fa265a2297344351381f524cdbb5542a2/pyfuse3-3.2.1.tar.gz"
    sha256 "22d146dac59a8429115e9a93317975ea54b35e0278044a94d3fac5b4ad5f7e33"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/f5/4f/280162d4bd4d8aad241a21aecff7a6e46891b905a4341e7ab549ebaf7915/requests-2.23.0.tar.gz"
    sha256 "b3f43d496c6daba4493e7c431722aeb7dbc6288f52a6e04e7b6023b0247817e6"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "trio" do
    url "https://files.pythonhosted.org/packages/0a/0f/e9c02a866e32d85fdead0f1c9425b31ba57b69dd08714770232089cc7839/trio-0.20.0.tar.gz"
    sha256 "670a52d3115d0e879e1ac838a4eb999af32f858163e3a704fe4839de2a676070"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    resources.each do |r|
      venv.pip_install r
    end

    # The inreplace changes the name of the (fsck|mkfs|mount|umount).s3ql
    # utilities to use underscore (_) as a separator, which is consistent
    # with other tools on macOS.
    # Final names: fsck_s3ql, mkfs_s3ql, mount_s3ql, umount_s3ql
    inreplace "setup.py", /'(?:(mkfs|fsck|mount|umount)\.)s3ql =/, "'\\1_s3ql ="

    system libexec/"bin/python3", "setup.py", "build_ext", "--inplace"
    venv.pip_install_and_link buildpath
  end

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
      EOS
    end
  end

  test do
    assert_match "S3QL ", shell_output(bin/"mount_s3ql --version")

    # create a local filesystem, and run an fsck on it
    assert_equal "Library\n", shell_output("ls")
    assert_match "Creating metadata", shell_output(bin/"mkfs_s3ql --plain local://#{testpath} 2>&1")
    assert_match "s3ql_metadata", shell_output("ls s3ql_metadata")
    system bin/"fsck_s3ql", "local://#{testpath}"
  end
end
