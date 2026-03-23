class Scrapy < Formula
  include Language::Python::Virtualenv

  desc "Web crawling & scraping framework"
  homepage "https://scrapy.org"
  url "https://files.pythonhosted.org/packages/ee/54/000e2b35f68243ae6e625aab1477bebb973e6a3e57ef926ffb975a536220/scrapy-2.14.2.tar.gz"
  sha256 "23bf5d37503ad16973bd09604b9c36249bd4bbc282c48ddedbf58105d4639337"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/scrapy/scrapy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "681b54746995d70b96767f94ed82be7fa29678a5dc7d1bc777609b42a75a0c1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bb65e4240b79fa1825c6599f7c26f346a056fa48879442dc7d67c677f8a07c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c45a64f81e8f4eaa596dc3615123a2d023003d7d09b1d1b781222608c9c9d10b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c7df1b14d947c82102f84e815e54e4b83d019caae96a42b1977130a6b6a83aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9541ccd522e4a714437e7fad5e99033cd56dfae0ca58422e9c692d97dda05fc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9aa3c5b14d22fccfc55d5bcdb277ee47ec3bc78402fd8e05213e542055ac2ae4"
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
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "constantly" do
    url "https://files.pythonhosted.org/packages/4d/6f/cb2a94494ff74aa9528a36c5b1422756330a75a8367bf20bd63171fc324d/constantly-23.10.4.tar.gz"
    sha256 "aa92b70a33e2ac0bb33cd745eb61776594dc48764b06c35e0efd050b7f1c7cbd"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/ec/2e/cdfd8b01c37cbf4f9482eefd455853a3cf9c995029a46acd31dfaa9c1dd6/cssselect-1.4.0.tar.gz"
    sha256 "fdaf0a1425e17dfe8c5cf66191d211b357cf7872ae8afc4c6762ddd8ac47fc92"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/94/b8/00651a0f559862f3bb7d6f7477b192afe3f583cc5e26403b44e59a55ab34/filelock-3.25.2.tar.gz"
    sha256 "b64ece2b38f4ca29dd3e810287aa8c48182bbecd1ae6e9ae126c9b35f1382694"
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
    url "https://files.pythonhosted.org/packages/05/bd/916f4fd26e14e6ad292b69693ccca4f192bcaf9f817ba7d6f7162dbbd835/itemloaders-1.4.0.tar.gz"
    sha256 "b5338308a819098f43525b7afc5f7d46ba338ba4710f5ebe7a21b3b47bb29929"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "parsel" do
    url "https://files.pythonhosted.org/packages/91/c8/4ace3a5c61e39ca21734a5715d0e076eea6200dd8daea2a5b99452f5a0d6/parsel-1.11.0.tar.gz"
    sha256 "5925fe087eb16fc404a7ed91e31e2c1e2a9b230da4b64f34d81358c0d0e27e88"
  end

  resource "protego" do
    url "https://files.pythonhosted.org/packages/07/a7/955c422611d00a6e4a06d30b367ea9bb4fb09d48552e92aef1ba312493c7/protego-0.6.0.tar.gz"
    sha256 "3466f41438421cf90008e98534d5fde47dc16a17482571d021143ac18b70ace9"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/5c/5f/6583902b6f79b399c9c40674ac384fd9cd77805f9e6205075f828ef11fb2/pyasn1-0.6.3.tar.gz"
    sha256 "697a8ecd6d98891189184ca1fa05d1bb00e2f84b5977c481452050549c8a72cf"
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
    url "https://files.pythonhosted.org/packages/8e/11/a62e1d33b373da2b2c2cd9eb508147871c80f12b1cacde3c5d314922afdd/pyopenssl-26.0.0.tar.gz"
    sha256 "f293934e52936f2e3413b89c6ce36df66a0b34ae1ea3a053b8c5020ff2f513fc"
  end

  resource "queuelib" do
    url "https://files.pythonhosted.org/packages/76/f3/d80ab8c7c91b8c42d9a2aa4dd97a8be1321e7b26000c2675b75e641d958c/queuelib-1.9.0.tar.gz"
    sha256 "b12fea79fd8c1dd23e212b1f3db58003b773949801d4f4e6f34d882467d4a192"
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
    url "https://files.pythonhosted.org/packages/f1/91/186665abf1a6d16c0c5ea1f0e681d9c852b45c3a750aa8657f8f956690a8/w3lib-2.4.0.tar.gz"
    sha256 "e233ad21649b69d0e047a10f30181ae9677524a29f6f71f6f3c758dc0c8d2648"
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
