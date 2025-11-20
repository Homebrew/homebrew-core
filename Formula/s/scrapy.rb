class Scrapy < Formula
  include Language::Python::Virtualenv

  desc "Web crawling & scraping framework"
  homepage "https://scrapy.org"
  url "https://files.pythonhosted.org/packages/08/ef/827db21986672723741ef1c384f4e5a09b0a552936ae638b6426e71d3a6e/scrapy-2.13.4.tar.gz"
  sha256 "e09bce40c56b56f9f86b0d078a0e5cdd08283c83076170ce7a8eec7189ac2493"
  license "BSD-3-Clause"
  head "https://github.com/scrapy/scrapy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a134d804685aea4546d725d947e251cc3b4f6b0ae7c17cee36a0eb1b4e514b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a43e161ce844d00d822539974bec9c260398ff1cb28c144b031c49f8bea1838a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "603c4e0d916b3f97d3018d9c2c378df2824cb76432366eab0af1b8a832b1874d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cc21d1b123b2ae46289871b9273c67ae3cac2572695bb9de2ab4eba4235a32e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97393edcddcf67c95b32cf2804d02a9f16309d4e294b087179d87eb643423e64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbc4d3ea619b7e49e2bd367f58713e444c0382452f8c79ec63c6693f1352cea5"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "automat" do
    url "https://files.pythonhosted.org/packages/e3/0f/d40bbe294bbf004d436a8bcbcfaadca8b5140d39ad0ad3d73d1a8ba15f14/automat-25.4.16.tar.gz"
    sha256 "0017591a5477066e90d26b0e696ddc143baafd87b588cfac8100bc6be9634de0"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/4d/6f/cb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324d/constantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/72/0a/c3ea9573b1dc2e151abfe88c7fe0c26d1892fe6ed02d0cdb30f0d57029d5/cssselect-1.3.0.tar.gz"
    sha256 "57f8a99424cfab289a1b6a816a43075a4b00948c86b4dcf3ef4ee7e15f7ab0c7"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/58/46/0028a82567109b5ef6e4d2a1f04a583fb513e6cf9527fcdd09afd817deeb/filelock-3.20.0.tar.gz"
    sha256 "711e943b4ec6be42e1d4e6690b48dc175c822967466bb31c0c293f34334c13f4"
  end

  resource "hyperlink" do
    url "https://files.pythonhosted.org/packages/3a/51/1947bd81d75af87e3bb9e34593a4cf118115a8feb451ce7a69044ef1412e/hyperlink-21.0.0.tar.gz"
    sha256 "427af957daa58bc909471c6c40f74c5450fa123dd093fc53efd2e91d2705a56b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "incremental" do
    url "https://files.pythonhosted.org/packages/27/87/156b374ff6578062965afe30cc57627d35234369b3336cf244b240c8d8e6/incremental-24.7.2.tar.gz"
    sha256 "fb4f1d47ee60efe87d4f6f0ebb5f70b9760db2b2574c59c8e8912be4ebd464c9"
  end

  resource "itemadapter" do
    url "https://files.pythonhosted.org/packages/e9/50/2fd91416acfbd316b58de909cfc2a5c2daaa4ced67fb76cb0dedcbd13197/itemadapter-0.12.2.tar.gz"
    sha256 "8e05c07cea966a7a8c4f096150ee2c91d9b4104a76f9afd029b235e1b564a61f"
  end

  resource "itemloaders" do
    url "https://files.pythonhosted.org/packages/b6/3e/c549370e95c9dc7ec5e155c075e2700fa75abe5625608a4ce5009eabe0bf/itemloaders-1.3.2.tar.gz"
    sha256 "4faf5b3abe83bf014476e3fd9ccf66867282971d9f1d4e96d9a61b60c3786770"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "parsel" do
    url "https://files.pythonhosted.org/packages/f6/df/acd504c154c0b9028b0d8491a77fdd5f86e9c06ee04f986abf85e36d9a5f/parsel-1.10.0.tar.gz"
    sha256 "14f17db9559f51b43357b9dfe43cec870a8efb5ea4857abb624ec6ff80d8a080"
  end

  resource "protego" do
    url "https://files.pythonhosted.org/packages/19/9b/9c3a649167c7e43a0818df515d515e66d95a261fdfdf2a6afd45be9db696/protego-0.5.0.tar.gz"
    sha256 "225dee0acfcc71de8c6f7cef9c618e5a9d3e7baa7ae1470b8d076a064033c463"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pydispatcher" do
    url "https://files.pythonhosted.org/packages/21/db/030d0700ae90d2f9d52c2f3c1f864881e19cef8cba3b0a08759c8494c19c/PyDispatcher-2.0.7.tar.gz"
    sha256 "b777c6ad080dc1bad74a4c29d6a46914fa6701ac70f94b0d66fbcfde62f5be31"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/80/be/97b83a464498a79103036bc74d1038df4a7ef0e402cfaf4d5e113fb14759/pyopenssl-25.3.0.tar.gz"
    sha256 "c981cb0a3fd84e8602d7afc209522773b94c1c2446a3c710a75b06fe1beae329"
  end

  resource "queuelib" do
    url "https://files.pythonhosted.org/packages/4c/78/9ace6888cf6d390c9aec3ba93020838b08934959b544a7f10b15db815d29/queuelib-1.8.0.tar.gz"
    sha256 "582bc65514481100b0539bd671da6b355b878869cfc77d92c63b75fcc9cf8e27"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/3c/f8/5dc70102e4d337063452c82e1f0d95e39abfe67aa222ed8a5ddeb9df8de8/requests_file-3.0.1.tar.gz"
    sha256 "f14243d7796c588f3521bd423c5dea2ee4cc730e54a3cac9574d78aca1272576"
  end

  resource "service-identity" do
    url "https://files.pythonhosted.org/packages/07/a5/dfc752b979067947261dbbf2543470c58efe735c3c1301dd870ef27830ee/service_identity-24.2.0.tar.gz"
    sha256 "b8683ba13f0d39c6cd5d625d2c5f65421d6d707b013b375c355751557cbe8e09"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/97/78/182641ea38e3cfd56e9c7b3c0d48a53d432eea755003aa544af96403d4ac/tldextract-5.3.0.tar.gz"
    sha256 "b3d2b70a1594a0ecfa6967d57251527d58e00bb5a91a74387baa0d87a0678609"
  end

  resource "twisted" do
    url "https://files.pythonhosted.org/packages/13/0f/82716ed849bf7ea4984c21385597c949944f0f9b428b5710f79d0afc084d/twisted-25.5.0.tar.gz"
    sha256 "1deb272358cb6be1e3e8fc6f9c8b36f78eb0fa7c2233d2dbe11ec6fee04ea316"

    # Fix asyncio error with Python 3.14, remove in next release
    # PR ref: https://github.com/twisted/twisted/pull/12508
    patch do
      url "https://github.com/twisted/twisted/commit/c8a4c700a71c283bd65faee69820f88ec97966cb.patch?full_index=1"
      sha256 "04b849f18e6ef01e7ee2903dba13ffa8bcb04c6d9c182d25410605320d819bd2"
    end
    patch do
      url "https://github.com/twisted/twisted/commit/69b81f9038eea5ef60c30a3460abb4cc26986f72.patch?full_index=1"
      sha256 "f999fc976327e955fbe82348dfd8c336925bc1f87cfaf4bd4c95deeb0570116d"
    end
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "w3lib" do
    url "https://files.pythonhosted.org/packages/bf/7d/1172cfaa1e29beb9bf938e484c122b3bdc82e8e37b17a4f753ba6d6e009f/w3lib-2.3.1.tar.gz"
    sha256 "5c8ac02a3027576174c2b61eb9a2170ba1b197cae767080771b6f1febda249a4"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/71/c9/5ec8679a04d37c797d343f650c51ad67d178f0001c363e44b6ac5f97a9da/zope_interface-8.1.1.tar.gz"
    sha256 "51b10e6e8e238d719636a401f44f1e366146912407b58453936b781a19be19ec"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrapy version")

    system bin/"scrapy", "startproject", "brewproject"
    cd testpath/"brewproject" do
      system bin/"scrapy", "genspider", "-t", "basic", "brewspider", "brew.sh"
      assert_match "INFO: Spider closed (finished)", shell_output("#{bin}/scrapy crawl brewspider 2>&1")
    end
  end
end
