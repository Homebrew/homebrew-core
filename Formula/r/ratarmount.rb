class Ratarmount < Formula
  include Language::Python::Virtualenv

  desc "Mount and efficiently access archives as filesystems"
  homepage "https://github.com/mxmlnkn/ratarmount"
  url "https://files.pythonhosted.org/packages/a5/80/f7f628af7652a89b7f400b23fea17395dd6b27949ae8a45b6e81d69bd810/ratarmount-1.3.0.tar.gz"
  sha256 "9e96f0f887db67a3ea68c4ecc625c05a3636cd8f29d80491eb170d934d3caa00"
  license "MIT"
  revision 2
  head "https://github.com/mxmlnkn/ratarmount.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_linux:  "37cc093abd33d83ebbc5b2563dae1eb84ed449a106f967726ef0ff77a1232fe1"
    sha256 cellar: :any, x86_64_linux: "b1514e23dfbd7d6e47cb25e06a61ff9fd05a7ba7f932346cae801edd0f2b9f88"
  end

  depends_on "libfuse" => :no_linkage
  depends_on :linux
  depends_on "python@3.15"
  depends_on "zlib-ng-compat"
  depends_on "zstd"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/cf/81/1546c983678a9b4e77cb4718eaedd1b2caf24a6cdbf1eb8775938d22aff7/brotli-1.2.1.tar.gz"
    sha256 "02b2f7b5a83485efe448a44ddf7983def05c3bb1dcf917d4f7154070260e13de"
  end

  resource "fast-zip-decryption" do
    url "https://files.pythonhosted.org/packages/47/c8/0fbde8b9c8314e4fde35f4841015a6143967d5fd4d141e84a6cf14e62178/fast_zip_decryption-3.0.0.tar.gz"
    sha256 "5267e45aab72161b035ddc4dda4ffa2490b6da1ca752e4ff7eaedd4dd18aa85d"
  end

  resource "indexed-gzip" do
    url "https://files.pythonhosted.org/packages/e8/f9/a127e4f1f806b18d43272b6d0bb56f74ca1a16628d60ebc674a62ebf37eb/indexed_gzip-1.10.3.tar.gz"
    sha256 "1347f3b6c5522c5c50db5d9e2801257cea86639e87b46c6635f22005ee3ded25"
  end

  resource "indexed-zstd" do
    url "https://files.pythonhosted.org/packages/fa/e8/ea4b66faf498e3712f5d2723151b892238789a17a093a21c685e3184f139/indexed_zstd-1.7.2.tar.gz"
    sha256 "36ab8a43026a3c3594e0d96786994c3f9b4c04039d952df2fadc1fd54a6597b0"
  end

  resource "inflate64" do
    url "https://files.pythonhosted.org/packages/3e/f3/41bb2901543abe7aad0b0b0284ae5854bb75f848cf406bf8a046bf525f67/inflate64-1.0.4.tar.gz"
    sha256 "b398c686960c029777afc0ed281a86f66adb956cfc3fbf6667cc6453f7b407ce"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/26/23/e72434d5457c24113e0c22605cbf7dd806a2561294a335047f5aa8ddc1ca/libarchive_c-5.3.tar.gz"
    sha256 "5ddb42f1a245c927e7686545da77159859d5d4c6d00163c59daff4df314dae82"
  end

  resource "mfusepy" do
    url "https://files.pythonhosted.org/packages/91/47/746287c8962274f73ee25edb3840d80899464bfffbe2c435424c2d60a071/mfusepy-3.1.1.tar.gz"
    sha256 "338ece54513d7d1a5e9492837679a0c7432ecf96a03490a2683a1ce1d19570e1"
  end

  resource "multivolumefile" do
    url "https://files.pythonhosted.org/packages/50/f0/a7786212b5a4cb9ba05ae84a2bbd11d1d0279523aea0424b6d981d652a14/multivolumefile-0.2.3.tar.gz"
    sha256 "a0648d0aafbc96e59198d5c17e9acad7eb531abea51035d08ce8060dcad709d6"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "py7zr" do
    url "https://files.pythonhosted.org/packages/d6/31/d5469ec310b57c730785068c227caf2263391be846ae5e99488f69b394eb/py7zr-1.1.4.tar.gz"
    sha256 "7674697559bd06b697bf6e8249985cee6dc704a4b07b8e11f24d0b1695707c3e"
  end

  resource "pybcj" do
    url "https://files.pythonhosted.org/packages/14/c9/e2de4f98c21f2ff9e58047395b6a8e17701a0f2977f0e63f80948f61647f/pybcj-1.0.8.tar.gz"
    sha256 "6818270692912d47e81ccd777b7d0ed2ad3a19ef7aaead3735b38048c80bf368"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/f4/e7/50e72301e32acb73a314e663c2014e1ddefc019d5f434ff14ec89861d664/pycryptodomex-3.24.1.tar.gz"
    sha256 "09081666ffc599976c0b8b29caf2cf82212c0f05bed233c8f8ed53e4f6e1d356"
  end

  resource "pyppmd" do
    url "https://files.pythonhosted.org/packages/81/d7/803232913cab9163a1a97ecf2236cd7135903c46ac8d49613448d88e8759/pyppmd-1.3.1.tar.gz"
    sha256 "ced527f08ade4408c1bfc5264e9f97ffac8d221c9d13eca4f35ec1ec0c7b6b2e"
  end

  resource "python-xz" do
    url "https://files.pythonhosted.org/packages/fe/2f/7ed0c25005eba0efb1cea3cdf4a325852d63167cc77f96b0a0534d19e712/python-xz-0.4.0.tar.gz"
    sha256 "398746593b706fa9fac59b8c988eab8603e1fe2ba9195111c0b45227a3a77db3"
  end

  resource "rapidgzip" do
    url "https://files.pythonhosted.org/packages/d6/50/b9bb77eaf841f2fbd8123d9677815d4ef53b53c4c189c5f789c78ef2d05e/rapidgzip-0.15.2.tar.gz"
    sha256 "fa3f90f17ce185a99514df54b5316bdfa593e98f3eebbb12da301eb25d6dedcd"
  end

  resource "rarfile" do
    url "https://files.pythonhosted.org/packages/b2/eb/33ea5625de4e84144069ea021a282ea3c44ff7bd341b740bcadff028bea7/rarfile-4.5.tar.gz"
    sha256 "7425d0afa180f0092db903abb1526a130b36858980aad90b3694f48e41420155"
  end

  resource "ratarmountcore" do
    url "https://files.pythonhosted.org/packages/ad/c6/372bb4ee86a069bfb39998f6056cdf65f1c79a70c3b91954041b996dfe79/ratarmountcore-0.11.1.tar.gz"
    sha256 "9b05690c6ac0e561e77c5cdbc1559447233b2fc6bd37ad1e9b29acc99dec509d"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/03/19/9590fd39a668ea0a0869493441fe65852246a3ec67616877baad98bcb039/texttable-1.7.2.tar.gz"
    sha256 "dc16ea6b35fbf5291ba6ef79d79e37d9b3ca6acd7bae3ca3450488d7c2e19c99"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ratarmount #{version}", shell_output("#{bin}/ratarmount --version 2>&1")
    tarball = test_fixtures("tarballs/testball2-0.1.tbz")
    assert_match "FUSE mountpoint could not be created",
                 shell_output("#{bin}/ratarmount #{tarball} #{testpath}/mount 2>&1", 1)
  end
end
