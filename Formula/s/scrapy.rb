class Scrapy < Formula
  include Language::Python::Virtualenv

  desc "Web crawling & scraping framework"
  homepage "https://scrapy.org"
  url "https://files.pythonhosted.org/packages/db/fb/0ccc11eaabdac1f210f27fb6b2ad4aa4ff8a5085cbc616102536fe2c56f4/scrapy-2.14.1.tar.gz"
  sha256 "b2a4e61802e0a5518bc8293058adedbb6b0d51c08c125d1322b1af7c7cbca4c1"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/scrapy/scrapy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "adf60e63466d69c7ecbdaa039ec52db39ca53ecc2bf038ebd34837c3428a1ec7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67a2bcce8fbd6586f613428133249ff795c699257b76da409b60b484d51fd9c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "469ebb9721dfd9c7269819eb6e7828537974e36f76378cfd9d622300d41c260e"
    sha256 cellar: :any_skip_relocation, sonoma:        "39666b581cf3aa60fb7e421b8bff677a317cd0399fbf717b4a128e850e41a98e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7b66503f6eaf0be160b6c357c68fad6b67babacac3fc5f16c1515ba1dea4242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eefe161b06cb8459e9b7ab06e2eb3c61d5ccc65d36739bc6aa61960fdf567580"
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
    url "https://files.pythonhosted.org/packages/1d/65/ce7f1b70157833bf3cb851b556a37d4547ceafc158aa9b34b36782f23696/filelock-3.20.3.tar.gz"
    sha256 "18c57ee915c7ec61cff0ecf7f0f869936c7c30191bb0cf406f1341778d0834e1"
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
    url "https://files.pythonhosted.org/packages/ef/3c/82e84109e02c492f382c711c58a3dd91badda6d746def81a1465f74dc9f5/incremental-24.11.0.tar.gz"
    sha256 "87d3480dbb083c1d736222511a8cf380012a8176c2456d01ef483242abbbcf8c"
  end

  resource "itemadapter" do
    url "https://files.pythonhosted.org/packages/52/47/4c75c5396941e653d5f864389964da6951e8f338c6739602dd778f62333e/itemadapter-0.13.1.tar.gz"
    sha256 "fa139c7be2aa80f8874b2f23d165d5d4aa47c4b85c54ab530b567fd5f684f1b4"
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
    url "https://files.pythonhosted.org/packages/fe/b6/6e630dff89739fcd427e3f72b3d905ce0acb85a45d4ec3e2678718a3487f/pyasn1-0.6.2.tar.gz"
    sha256 "9b59a2b25ba7e4f8197db7686c09fb33e658b98339fadb826e9512629017833b"
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

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/65/7b/644fbbb49564a6cb124a8582013315a41148dba2f72209bba14a84242bf0/tldextract-5.3.1.tar.gz"
    sha256 "a72756ca170b2510315076383ea2993478f7da6f897eef1f4a5400735d5057fb"
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
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "w3lib" do
    url "https://files.pythonhosted.org/packages/bf/7d/1172cfaa1e29beb9bf938e484c122b3bdc82e8e37b17a4f753ba6d6e009f/w3lib-2.3.1.tar.gz"
    sha256 "5c8ac02a3027576174c2b61eb9a2170ba1b197cae767080771b6f1febda249a4"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/86/a4/77daa5ba398996d16bb43fc721599d27d03eae68fe3c799de1963c72e228/zope_interface-8.2.tar.gz"
    sha256 "afb20c371a601d261b4f6edb53c3c418c249db1a9717b0baafc9a9bb39ba1224"
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
