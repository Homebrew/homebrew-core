class S3ql < Formula
  include Language::Python::Virtualenv

  desc "POSIX-compliant FUSE filesystem using object store as block storage"
  homepage "https://github.com/s3ql/s3ql"
  url "https://github.com/s3ql/s3ql/releases/download/s3ql-6.1.0/s3ql-6.1.0.tar.gz"
  sha256 "b4ac7c81a89e790999fa4473e302bf5e1b5bb8abe3303f88f6fdb73beecc7cfc"
  license "GPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c818f589fbdf39d7efcfcbbf81a22f8826a3fcc15a70969225ca9b2e5dcb7c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1bfe4b9ca1017c415ede3e7de3719af488a6b4081361a808260826043871f693"
  end

  depends_on "pkgconf" => :build

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libffi"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "python@3.14"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "apsw" do
    url "https://files.pythonhosted.org/packages/5a/5f/0fabac91b26d222f5ad1bf8af92f6c80d82af2e50dafb401a250a02b2f53/apsw-3.53.1.0.tar.gz"
    sha256 "4f8978ae8c7c405d0133a6ea590f3342f839143bdf39e46029cb36e2fa418692"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/d4/f8/80d2493cbedece1c623dc3e3cb1883300871af0dcdae254409522985ac23/google_auth-2.52.0.tar.gz"
    sha256 "01f30e1a9e3638698d89464f5e603ce29d18e1c0e63ec31ac570aba4e164aaf5"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/70/18/90c7fac516e63cf2058166fce0c88c353647c677b51cc036c09c49bb5cbb/google_auth_oauthlib-1.4.0.tar.gz"
    sha256 "18b5e28880eb8eba9065c436becdc0ee8e4b59117a73a510679c82f70cd363d2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ce/cc/762dfb036166873f0059f3b7de4565e1b5bc3d6f28a414c13da27e442f99/idna-3.13.tar.gz"
    sha256 "585ea8fe5d69b9181ec1afba340451fba6ba764af97026f92a91d4eef164a242"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "outcome" do
    url "https://files.pythonhosted.org/packages/98/df/77698abfac98571e65ffeb0c1fba8ffd692ab8458d617a0eed7d9a8d38f2/outcome-1.3.0.post0.tar.gz"
    sha256 "9dcf02e65f2971b80047b377468e72a268e15c0af3cf1238e6ff14f7f91143b8"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/5c/5f/6583902b6f79b399c9c40674ac384fd9cd77805f9e6205075f828ef11fb2/pyasn1-0.6.3.tar.gz"
    sha256 "697a8ecd6d98891189184ca1fa05d1bb00e2f84b5977c481452050549c8a72cf"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pyfuse3" do
    url "https://files.pythonhosted.org/packages/98/c8/8d4b00354b0aae1660310c6853cad7228af7efc344b3ff7d8cc4a894343d/pyfuse3-3.4.2.tar.gz"
    sha256 "0a59031969c4ba51a5ec1b67f3c5c24f641a6a3f8119a86edad56debcb9084d9"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "trio" do
    url "https://files.pythonhosted.org/packages/52/b6/c744031c6f89b18b3f5f4f7338603ab381d740a7f45938c4607b2302481f/trio-0.33.0.tar.gz"
    sha256 "a29b92b73f09d4b48ed249acd91073281a7f1063f09caba5dc70465b5c7aa970"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources

    # Create temporary compatibility executables for previous patched names.
    # Remove them after 2 minor releases, i.e. 6.2.0, or next major release.
    odie "Remove compatibility scripts!" if version >= "6.2.0"
    %w[mkfs fsck mount umount].each do |cmd|
      old_cmd = "#{cmd}_s3ql"
      new_cmd = "#{cmd}.s3ql"
      (bin/old_cmd).write <<~SHELL
        #!/bin/bash
        echo "WARNING: #{old_cmd} has been renamed to #{new_cmd}; #{old_cmd} will be removed in 6.2.0." >&2
        exec "#{bin/new_cmd}" "$@"
      SHELL
    end
  end

  test do
    assert_match "S3QL ", shell_output("#{bin}/mount_s3ql --version") # TODO: remove in 6.2.0
    assert_match "S3QL ", shell_output("#{bin}/mount.s3ql --version")

    # create a local filesystem, and run an fsck on it
    assert_match "Creating metadata", shell_output("#{bin}/mkfs.s3ql --plain local://#{testpath} 2>&1")
    assert_path_exists testpath/"s3ql_params"
    system bin/"fsck.s3ql", "local://#{testpath}"
  end
end
