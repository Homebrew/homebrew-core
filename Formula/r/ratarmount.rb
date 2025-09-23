class Ratarmount < Formula
  include Language::Python::Virtualenv

  desc "Mount and efficiently access archives as filesystems"
  homepage "https://github.com/mxmlnkn/ratarmount"
  url "https://files.pythonhosted.org/packages/e0/5c/ffddb34553d65cb9bf1a0baa59bb61fcf3beebab0e0a944347a501b2e258/ratarmount-1.2.0.tar.gz"
  sha256 "acca4e5803c75f50f94d4c75ead5f44aa4c4661c9e77d50eb25d1876e6f4dec9"
  license "MIT"
  head "https://github.com/mxmlnkn/ratarmount.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a2cbf6c298da3347b8d7f4cffd240518783716a732ed96e40925a03219103669"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7d517c03dc5d4d9b8fcfeeeb33e189e0163b79c5cf1566a7b85d0014e5ff7180"
  end

  depends_on "libffi"
  depends_on "libfuse"
  depends_on "libgit2"
  depends_on :linux
  depends_on "python@3.13"
  depends_on "zlib"
  depends_on "zstd"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "fast-zip-decryption" do
    url "https://files.pythonhosted.org/packages/47/c8/0fbde8b9c8314e4fde35f4841015a6143967d5fd4d141e84a6cf14e62178/fast_zip_decryption-3.0.0.tar.gz"
    sha256 "5267e45aab72161b035ddc4dda4ffa2490b6da1ca752e4ff7eaedd4dd18aa85d"
  end

  resource "indexed-gzip" do
    url "https://files.pythonhosted.org/packages/d4/22/e9e94407bae83444adf598535b684d28cfbbcbe19f58eeba46f4db7bc0f3/indexed_gzip-1.10.1.tar.gz"
    sha256 "3993fd72570b254045d2361d937a984350719f2205066f4e4c16435a1df361e3"
  end

  resource "indexed-zstd" do
    url "https://files.pythonhosted.org/packages/52/22/5b908d5e987043ce8390b0d9101c93fae0c0de0c9c8417c562976eeb8be6/indexed_zstd-1.6.1.tar.gz"
    sha256 "8b74378f9461fceab175215b65e1c489864ddb34bd816058936a627f0cca3a8b"
  end

  resource "inflate64" do
    url "https://files.pythonhosted.org/packages/e3/a7/974e6daa6c353cf080b540c18f11840e81b36d18106963a0a857b1fc2adf/inflate64-1.0.3.tar.gz"
    sha256 "a89edd416c36eda0c3a5d32f31ff1555db2c5a3884aa8df95e8679f8203e12ee"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/26/23/e72434d5457c24113e0c22605cbf7dd806a2561294a335047f5aa8ddc1ca/libarchive_c-5.3.tar.gz"
    sha256 "5ddb42f1a245c927e7686545da77159859d5d4c6d00163c59daff4df314dae82"
  end

  resource "mfusepy" do
    url "https://files.pythonhosted.org/packages/1c/94/c9d5dcba4a6a2b32ba23e22fd13ca08e6f5408420b2dfe42984af22277b6/mfusepy-3.0.0.tar.gz"
    sha256 "eddade33e427bac9c455464cd0a7d12d63c033255ec6b1e0d6ada143a945c6f2"
  end

  resource "multivolumefile" do
    url "https://files.pythonhosted.org/packages/50/f0/a7786212b5a4cb9ba05ae84a2bbd11d1d0279523aea0424b6d981d652a14/multivolumefile-0.2.3.tar.gz"
    sha256 "a0648d0aafbc96e59198d5c17e9acad7eb531abea51035d08ce8060dcad709d6"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "py7zr" do
    url "https://files.pythonhosted.org/packages/97/62/d6f18967875aa60182198a0dd287d3a50d8aea1d844239ea00c016f7be88/py7zr-1.0.0.tar.gz"
    sha256 "f6bfee81637c9032f6a9f0eb045a4bfc7a7ff4138becfc42d7cb89b54ffbfef1"
  end

  resource "pybcj" do
    url "https://files.pythonhosted.org/packages/ce/75/bbcf098abf68081fa27c09d642790daa99d9156132c8b0893e3fecd946ab/pybcj-1.0.6.tar.gz"
    sha256 "70bbe2dc185993351955bfe8f61395038f96f5de92bb3a436acb01505781f8f2"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pyppmd" do
    url "https://files.pythonhosted.org/packages/f6/d7/b3084ff1ac6451ef7dd93d4f7627eeb121a3bed4f8a573a81978a43ddb06/pyppmd-1.2.0.tar.gz"
    sha256 "cc04af92f1d26831ec96963439dfb27c96467b5452b94436a6af696649a121fd"
  end

  resource "python-xz" do
    url "https://files.pythonhosted.org/packages/fe/2f/7ed0c25005eba0efb1cea3cdf4a325852d63167cc77f96b0a0534d19e712/python-xz-0.4.0.tar.gz"
    sha256 "398746593b706fa9fac59b8c988eab8603e1fe2ba9195111c0b45227a3a77db3"
  end

  resource "pyzstd" do
    url "https://files.pythonhosted.org/packages/8f/a2/54d860ccbd07e3c67e4d0321d1c29fc7963ac82cf801a078debfc4ef7c15/pyzstd-0.17.0.tar.gz"
    sha256 "d84271f8baa66c419204c1dd115a4dec8b266f8a2921da21b81764fa208c1db6"
  end

  resource "rapidgzip" do
    url "https://files.pythonhosted.org/packages/fa/df/f4abf845cb27f60156b124af95f483d2861cd607811120650293a1835327/rapidgzip-0.15.0.tar.gz"
    sha256 "e81079c190c458652076f3667f90aa5886fbf2c92a5a3d0169cfb1faf1e45dfa"
  end

  resource "rarfile" do
    url "https://files.pythonhosted.org/packages/26/3f/3118a797444e7e30e784921c4bfafb6500fb288a0c84cb8c32ed15853c16/rarfile-4.2.tar.gz"
    sha256 "8e1c8e72d0845ad2b32a47ab11a719bc2e41165ec101fd4d3fe9e92aa3f469ef"
  end

  resource "ratarmountcore" do
    url "https://files.pythonhosted.org/packages/60/ab/3f75901c28a4680d0e416b3e618587e25422613dd4735ad98cad74a40a7e/ratarmountcore-0.10.0.tar.gz"
    sha256 "178d8f6be572e22847264f34c4b0d2166bec8b6de650b69e485b60e98a7c1ba0"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/1c/dc/0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2/texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
  end

  def install
    venv = virtualenv_install_with_resources without: "pyzstd"
    # We need to build separately to link to our `zstd`.
    resource("pyzstd").stage do
      system_zstd = "--config-settings=--build-option=--dynamic-link-zstd"
      system venv.root/"bin/python", "-m", "pip", "install", system_zstd,
                                     *std_pip_args(prefix: false, build_isolation: true), "."
    end
  end

  test do
    assert_match "ratarmount #{version}", shell_output("#{bin}/ratarmount --version 2>&1")
    tarball = test_fixtures("tarballs/testball2-0.1.tbz")
    assert_match "FUSE mountpoint could not be created", shell_output("#{bin}/ratarmount #{tarball} 2>&1", 1)
  end
end
