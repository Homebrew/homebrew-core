class Ratarmount < Formula
  include Language::Python::Virtualenv

  desc "Mount and efficiently access archives as filesystems"
  homepage "https://github.com/mxmlnkn/ratarmount"
  url "https://files.pythonhosted.org/packages/9a/38/b99223940402cc2eba3b6c8586fbbfb9e91cc7fda691fc4e5d4cdbda4c86/ratarmount-1.2.2.tar.gz"
  sha256 "4f0675d4ac4562a413ae4d381829368a02c8f5b518a85254f1ff08dafbe7ab7f"
  license "MIT"
  head "https://github.com/mxmlnkn/ratarmount.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d7e1c621794b272e190e7c207c045e44c3da689d4f8f903bd7a067188d35f75c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "59520ffb4fc93a8a0470081a5c97125021dbea5caf59962795063170a8f9225a"
  end

  depends_on "libfuse" => :no_linkage
  depends_on :linux
  depends_on "python@3.14"
  depends_on "zlib-ng-compat"
  depends_on "zstd"

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
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
    url "https://files.pythonhosted.org/packages/57/b6/96ce71640c3896cb4fcc4f071eb321d05016d64ea694d5d346da12c911d9/indexed_zstd-1.7.0.tar.gz"
    sha256 "b08f417c562f7e7c91454735d5ecec0a132fd0f4aa789b50bb1c6b466e14b504"
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
    url "https://files.pythonhosted.org/packages/0c/e6/01fb15361ca75ee5d01df6361825a49816a836c99980c5481da0e40c6877/py7zr-1.1.0.tar.gz"
    sha256 "087b1a94861ad9eb4d21604f6aaa0a8986a7e00580abd79fedd6f82fecf0592c"
  end

  resource "pybcj" do
    url "https://files.pythonhosted.org/packages/12/0c/2670b672655b18454841b8e88f024b9159d637a4c07f6ce6db85accf8467/pybcj-1.0.7.tar.gz"
    sha256 "72d64574069ffb0a800020668376b7ebd7adea159adbf4d35f8effc62f0daa67"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
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
    url "https://files.pythonhosted.org/packages/26/3f/3118a797444e7e30e784921c4bfafb6500fb288a0c84cb8c32ed15853c16/rarfile-4.2.tar.gz"
    sha256 "8e1c8e72d0845ad2b32a47ab11a719bc2e41165ec101fd4d3fe9e92aa3f469ef"
  end

  resource "ratarmountcore" do
    url "https://files.pythonhosted.org/packages/69/db/845aac13bee32f391606ae4118b21564f0e2537af5d2882e0ff1ac3b6e47/ratarmountcore-0.10.3.tar.gz"
    sha256 "259644bc057b844ba6f73edd9923118757e0933f2ea6c54d841e2f897f2a5f5f"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/1c/dc/0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2/texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
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
