class Twtxt < Formula
  desc "Decentralised, minimalist microblogging service for hackers"
  homepage "https://github.com/buckket/twtxt"
  url "https://github.com/buckket/twtxt/archive/v1.2.3.tar.gz"
  sha256 "73b9d4988f96cc969c0c50ece0e9df12f7385735db23190e40c0d5e16f7ccd8c"
  license "MIT"
  revision 4

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

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/c0/b9/853b158f5cb5d218daaff0fb0dbc2bd7de45b2c6c5f563dff0ee530ec52a/aiohttp-2.3.10.tar.gz"
    sha256 "8adda6583ba438a4c70693374e10b60168663ffa6564c5c75d3c7a9055290964"
  end

  resource "async_timeout" do
    url "https://files.pythonhosted.org/packages/a1/78/aae1545aba6e87e23ecab8d212b58bb70e72164b67eb090b81bb17ad38e3/async-timeout-3.0.1.tar.gz"
    sha256 "0c3c816a028d47f659d6ff5c745cb2acf1f966da1fe5c19c77a70282b25f4c5f"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
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
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "idna_ssl" do
    url "https://files.pythonhosted.org/packages/46/03/07c4894aae38b0de52b52586b24bf189bb83e4ddabfe2e2c8f2419eec6f4/idna-ssl-1.1.0.tar.gz"
    sha256 "a933e3bb13da54383f9e8f35dc4f9cb9eb9b3b78c6b36f311254d6d0d92c6c7c"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/84/96/5503ba866d8d216e49a6ce3bcb288df8a5fb3ac8a90b8fcff9ddcda32568/multidict-4.7.3.tar.gz"
    sha256 "be813fb9e5ce41a5a99a29cdb857144a1bd6670883586f995b940a4878dc5238"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/d6/67/6e2507586eb1cfa6d55540845b0cd05b4b77c414f6bca8b00b45483b976e/yarl-1.4.2.tar.gz"
    sha256 "58cd9c469eced558cd81aa3f484b2924e8897049e06889e8ff2510435b7ef74b"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
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
