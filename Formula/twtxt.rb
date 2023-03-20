class Twtxt < Formula
  include Language::Python::Virtualenv

  desc "Decentralised, minimalist microblogging service for hackers"
  homepage "https://github.com/buckket/twtxt"
  url "https://files.pythonhosted.org/packages/fc/4c/cff74642212dbca8d4d9059119555cd335324b3da0b52990a414a0257756/twtxt-1.3.1.tar.gz"
  sha256 "f15e580f8016071448b24048402b939b9e8dec07eabacd84b1f2878d751b71ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fbf230b361bf8c11d01850bbb8e316b749fad58319d19cb8b8701a582c7cb51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa2579916188569fa604666aaeec5015d565dab166d212e892f773d6a8d79862"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31949a7b052e08c2f0dc4710b5117c9e9af001ddfe92a10a7e067048b9de1f0f"
    sha256 cellar: :any_skip_relocation, ventura:        "40f79cc95f887f69cf476714c2d7e66284e8a4822e0b33a965e6e90cb6b20947"
    sha256 cellar: :any_skip_relocation, monterey:       "98797c0b31e95d67fd7cde3200b182572c74feb6233f2f6e428efe4593eee8e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b360e538860e99707c663b17a04a3f7b5c1d8f9df84581499b3593ca6b37ecd"
    sha256 cellar: :any_skip_relocation, catalina:       "c6265ceb2ade96a1912bce307331dcb518a0000434f5aec1192df084979afa22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da8ad8887bc0f886f55c15e6828eaef47110ce35078441a30756abc15feefa5a"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/ff/4f/62d9859b7d4e6dc32feda67815c5f5ab4421e6909e48cbc970b6a40d60b7/aiohttp-3.8.3.tar.gz"
    sha256 "3828fb41b7203176b82fe5d699e0d845435f2374750a44b480ea6b930f6be269"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/e9/10/d629476346112b85c912527b9080944fd2c39a816c2225413dbc0bb6fcc0/frozenlist-1.3.3.tar.gz"
    sha256 "58bcc55721e8a90b88332d6cd441261ebb22342e238296bb330968952fbb3a6a"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/51/19/3e1adf0e7a8c8361496b085edcab2ddcd85410735a2b6fdd044247fc5b75/humanize-4.4.0.tar.gz"
    sha256 "efb2584565cc86b7ea87a977a15066de34cdedaf341b11c851cfcfd2b964779c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/fa/a7/71c253cdb8a1528802bac7503bf82fe674367e4055b09c28846fdfa4ab90/multidict-6.0.2.tar.gz"
    sha256 "5ff3bd75f38e4c43f1f470f2df7a4d430b821c4ce22be384e1459cb57d6bb013"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/d6/04/255c68974ec47fa754564c4abba8f61f9ed68b869bbbb854198d6259c4f7/yarl-1.8.1.tar.gz"
    sha256 "af887845b8c2e060eb5605ff72b6f2dd2aab7a761379373fd89d314f4752abbf"
  end

  def install
    virtualenv_install_with_resources
  end

  # If the test needs to be updated, more users can be found here:
  # https://github.com/mdom/we-are-twtxt/blob/HEAD/we-are-twtxt.txt
  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"
    (testpath/"config").write <<~EOS
      [twtxt]
      nick = homebrew
      twtfile = twtxt.txt
      [following]
      abliss = https://abliss.keybase.pub/twtxt.txt#7a778276dd852edc65217e759cba637a28b4426b
    EOS
    (testpath/"twtxt.txt").write <<~EOS
      2016-02-05T18:00:56.626750+00:00  Homebrew speaks!
    EOS
    assert_match "PGP", shell_output("#{bin}/twtxt -c config timeline")
  end
end
