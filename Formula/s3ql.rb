class S3ql < Formula
  include Language::Python::Virtualenv

  desc "POSIX-compliant FUSE filesystem using object store as block storage"
  homepage "https://github.com/s3ql/s3ql"
  url "https://github.com/s3ql/s3ql/releases/download/release-2.33/s3ql-2.33.tar.bz2"
  sha256 "4eb12360ae8927a6e65538a7b48237561585a5775e5d8c67d023be1dd9a857ce"

  depends_on "pkg-config" => :build
  depends_on :osxfuse
  depends_on "python"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/55/54/3ce77783acba5979ce16674fc98b1920d00b01d337cfaaf5db22543505ed/certifi-2018.11.29.tar.gz"
    sha256 "47f9c83ef4c0c621eaef743f133f09fa8a74a9b75f037e8624f83bd1b6626cb7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/74/ba/4ba4e89e21b5a2e267d80736ea674609a0a33cc4435a6d748ef04f1f9374/defusedxml-0.5.0.tar.gz"
    sha256 "24d7f2f94f7f3cb6061acb215685e5125fbcdc40a857eff9de22518820b0a4f4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "apsw" do
    url "https://files.pythonhosted.org/packages/b5/a1/3de5a2d35fc34939672f4e1bd7d68cca359a31b76926f00d95f434c63aaa/apsw-3.9.2-r1.tar.gz"
    sha256 "dab96fd164dde9e59f7f27228291498217fa0e74048e2c08c7059d7e39589270"
  end

  resource "dugong" do
    url "https://files.pythonhosted.org/packages/47/e5/637ebacead14f1a17fbf2a2be2fd11b717e9ae4f0f912682c59792265506/dugong-3.7.2.tar.bz2"
    sha256 "f219070139c3c8867fa542316801b3cc17a95dba0f6e30f0f73963044ef88620"
  end

  resource "llfuse" do
    url "https://files.pythonhosted.org/packages/19/e7/26335a22c776c763d280c2985963cf2f31484b7d05b5d74a08433d08201d/llfuse-1.3.5.tar.bz2"
    sha256 "6e412a3d9be69162d49b8a4d6fb3c343d1c1fba847f4535d229e0ece2548ead8"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    %w[certifi urllib3 idna chardet pycrypto defusedxml requests apsw dugong llfuse].each do |r|
      venv.pip_install resource(r)
    end

    # The inreplace changes the name of the (fsck|mkfs|mount|umount).s3ql
    # utilities to use underscore (_) as a seperator, which is consistent
    # with other tools on macOS.
    # Final names: fsck_s3ql, mkfs_s3ql, mount_s3ql, umount_s3ql
    inreplace "setup.py", /'(?:(mkfs|fsck|mount|umount)\.)s3ql =/, "'\\1_s3ql ="
    system libexec/"bin/python3", "setup.py", "build_ext", "--inplace"
    venv.pip_install_and_link buildpath
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
