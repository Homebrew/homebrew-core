class Twtxt < Formula
  include Language::Python::Virtualenv

  desc "Decentralised, minimalist microblogging service for hackers"
  homepage "https://github.com/buckket/twtxt"
  url "https://files.pythonhosted.org/packages/3e/ea/65d5c2d8de5fd354586a193092e250c9907549026b3cda5a7be6c78e8df3/twtxt-1.2.3.tar.gz"
  sha256 "be1195b46c32804f4f5f4fc552da678f6c822c6604c54d9d09348613d687be12"
  license "MIT"
  revision 5

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9852b500238712033ba66f22e28ef4f029c135f25949cec24df55a20c541c779"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a54e1f05c92c1bf283b3d70b72c6585f823ab125f4563284f0c4b9028217d9b"
    sha256 cellar: :any_skip_relocation, monterey:       "7e8032c7a836dbe407b5d8cfa44c58f5a780538f18942c459b1487b777fd643a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab8fc8ebac9953a37c85360158f293eefa648f16bd3e3c3fdc8992fcf4eb978e"
    sha256 cellar: :any_skip_relocation, catalina:       "f02a3756e562ada9942eeac14cadb2113f22b67935b4d1e3a30a2890b3312855"
    sha256 cellar: :any_skip_relocation, mojave:         "42f444d72bfcb08a0f105628d4883e03c5ff522b6eda4f390f9434b79bc1fdb6"
    sha256 cellar: :any_skip_relocation, high_sierra:    "93e9cd335a6dd161246501db8e5fcbc9d38d5c4ab07136e47a3742359c043c59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df7580b38b109f4b1fd9e7e3c9bb13c23d2c795d088eaf4ca9b259ac0f2e0606"
  end

  depends_on "python@3.8"
  depends_on "six"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/c0/b9/853b158f5cb5d218daaff0fb0dbc2bd7de45b2c6c5f563dff0ee530ec52a/aiohttp-2.3.10.tar.gz"
    sha256 "8adda6583ba438a4c70693374e10b60168663ffa6564c5c75d3c7a9055290964"
  end

  resource "async_timeout" do
    url "https://files.pythonhosted.org/packages/a1/78/aae1545aba6e87e23ecab8d212b58bb70e72164b67eb090b81bb17ad38e3/async-timeout-3.0.1.tar.gz"
    sha256 "0c3c816a028d47f659d6ff5c745cb2acf1f966da1fe5c19c77a70282b25f4c5f"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/8c/e0/e512e4ac6d091fc990bbe13f9e0378f34cf6eecd1c6c268c9e598dcf5bb9/humanize-0.5.1.tar.gz"
    sha256 "a43f57115831ac7c70de098e6ac46ac13be00d69abbf60bdcac251344785bb19"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "idna_ssl" do
    url "https://files.pythonhosted.org/packages/46/03/07c4894aae38b0de52b52586b24bf189bb83e4ddabfe2e2c8f2419eec6f4/idna-ssl-1.1.0.tar.gz"
    sha256 "a933e3bb13da54383f9e8f35dc4f9cb9eb9b3b78c6b36f311254d6d0d92c6c7c"
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
    url "https://files.pythonhosted.org/packages/f6/da/46d1b3d69a9a0835dabf9d59c7eb0f1600599edd421a4c5a15ab09f527e0/yarl-1.7.2.tar.gz"
    sha256 "45399b46d60c253327a460e99856752009fcee5f5d3c80b2f7c0cae1c38d56dd"
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
