class Ratarmount < Formula
  include Language::Python::Virtualenv

  desc "Mount and efficiently access archives as filesystems"
  homepage "https://github.com/mxmlnkn/ratarmount"
  url "https://github.com/mxmlnkn/ratarmount/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "fc5fadfc4dc268613eb3df832a0b3a3bc7fd40cd119b6aff83beaaa29ed05254"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "71afbf252f7c7f0c94fe39b89175f2abffc5f7ff84b64eaee8e77d0d846e52e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9834cce582b558270e76d63e92a7a1aed99e55f43401c46c6d2c2910c7a7b284"
  end

  depends_on "libffi"
  depends_on "libfuse"
  depends_on "libgit2"
  depends_on :linux
  depends_on "python@3.13"
  depends_on "zlib"
  depends_on "zstd"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/fc/97/c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90d/cffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "fast-zip-decryption" do
    url "https://files.pythonhosted.org/packages/47/c8/0fbde8b9c8314e4fde35f4841015a6143967d5fd4d141e84a6cf14e62178/fast_zip_decryption-3.0.0.tar.gz"
    sha256 "5267e45aab72161b035ddc4dda4ffa2490b6da1ca752e4ff7eaedd4dd18aa85d"
  end

  resource "indexed-gzip" do
    url "https://files.pythonhosted.org/packages/f2/75/0eff2f73f451d8510a9ab90d96fb974b900cd68fcba0be1d21bc0da62dc2/indexed_gzip-1.9.4.tar.gz"
    sha256 "6b415e4a29e799d5a21756ecf309325997992f046ee93526b8fe4ff511502b60"
  end

  resource "indexed-zstd" do
    url "https://files.pythonhosted.org/packages/52/22/5b908d5e987043ce8390b0d9101c93fae0c0de0c9c8417c562976eeb8be6/indexed_zstd-1.6.1.tar.gz"
    sha256 "8b74378f9461fceab175215b65e1c489864ddb34bd816058936a627f0cca3a8b"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/a0/f9/3b6cd86e683a06bc28b9c2e1d9fe0bd7215f2750fd5c85dce0df96db8eca/libarchive-c-5.1.tar.gz"
    sha256 "7bcce24ea6c0fa3bc62468476c6d2f6264156db2f04878a372027c10615a2721"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/b7/ea/17aa8ca38750f1ba69511ceeb41d29961f90eb2e0a242b668c70311efd4e/pygit2-1.17.0.tar.gz"
    sha256 "fa2bc050b2c2d3e73b54d6d541c792178561a344f07e409f532d5bb97ac7b894"
  end

  resource "python-xz" do
    url "https://files.pythonhosted.org/packages/fe/2f/7ed0c25005eba0efb1cea3cdf4a325852d63167cc77f96b0a0534d19e712/python-xz-0.4.0.tar.gz"
    sha256 "398746593b706fa9fac59b8c988eab8603e1fe2ba9195111c0b45227a3a77db3"
  end

  resource "rapidgzip" do
    url "https://files.pythonhosted.org/packages/0b/ac/0eee3d3279618a3c3810ac6b012b8ee7c1a9f239c9fa37529e619a31bb93/rapidgzip-0.14.3.tar.gz"
    sha256 "7d35f0af1657b4051a90c3c0c2c0d2433f3ce839db930fdbed3d6516de2a5df1"
  end

  resource "rarfile" do
    url "https://files.pythonhosted.org/packages/26/3f/3118a797444e7e30e784921c4bfafb6500fb288a0c84cb8c32ed15853c16/rarfile-4.2.tar.gz"
    sha256 "8e1c8e72d0845ad2b32a47ab11a719bc2e41165ec101fd4d3fe9e92aa3f469ef"
  end

  resource "ratarmountcore" do
    url "https://files.pythonhosted.org/packages/a1/5a/5600a4abe37426e9f3206bed3519b392f01816679226f4058049ea0e4a7d/ratarmountcore-0.8.0.tar.gz"
    sha256 "f1991a79b020b94e75c37c92c199677c80186db5f86a7a9717def68f1ae08207"

    # Fix to use libfuse 3.16+ because of ABI problem
    # Issue ref: https://github.com/mxmlnkn/ratarmount/issues/153
    # But it is resolved in 3.17.x
    # Issue ref: https://github.com/libfuse/libfuse/issues/1029
    patch :DATA
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ratarmount #{version}", shell_output("#{bin}/ratarmount --version 2>&1")
    tarball = test_fixtures("tarballs/testball2-0.1.tbz")
    assert_match "FUSE mountpoint could not be created", shell_output("#{bin}/ratarmount #{tarball} 2>&1", 1)
  end
end

__END__
diff --git a/ratarmountcore/fusepy/fuse.py b/ratarmountcore/fusepy/fuse.py
index 5e8e976..aedfa06 100644
--- a/ratarmountcore/fusepy/fuse.py
+++ b/ratarmountcore/fusepy/fuse.py
@@ -171,7 +171,7 @@ if fuse_version_major != 2 and not (fuse_version_major == 3 and _system == 'Linu
         f"Found library {_libfuse_path} has wrong major version: {fuse_version_major}. "
         "Expected FUSE 2!"
     )
-if fuse_version_major == 3 and fuse_version_minor > 16:
+if fuse_version_major == 3 and fuse_version_minor > 17:
     raise AttributeError(
         f"Found library {_libfuse_path} is too new ({fuse_version_major}.{fuse_version_minor}) "
         "and will not be used because FUSE 3 has no track record of ABI compatibility."
