class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/a8/0a/592de80e5e0cf90db1e1bfb71ea865f5029b69a83b4f9be84ac7848b3812/twarc-2.11.3.tar.gz"
  sha256 "eba6323257070391f39fe8b7aa18744de7bbc8a0b7c279cf1b15c9aac22e9fd0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11a815f68a9292ed3baa323856cd4f93f8ebcfc9f90a1a471ecc2f16cd36e04b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "741564e4211e88c3d4697258f4959c8828b41b60f4c9558848c2b8ded848996d"
    sha256 cellar: :any_skip_relocation, monterey:       "c73a89008c37c6c2cbd71fd681c6d0bfcce81160144f647a23de8fc7dcfdf19f"
    sha256 cellar: :any_skip_relocation, big_sur:        "106cadd6c4f4a6f8669f3b7aa9ac24fa18460fb4e2473b4364618be00c23182e"
    sha256 cellar: :any_skip_relocation, catalina:       "71aad7b1c0e36078dffd31e6da4dce84272fb4c457058940a8d6c8deb603066e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04ec5a2747ca3a93136ccbf0e52739f03d3a09d5951a2250b65eac53daf5ce16"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/90/c2/4e37394b66e7211ad120f216fc2e8b38d4f43b89c8100dd3917c9da9bfc6/certifi-2022.6.15.1.tar.gz"
    sha256 "cffdcd380919da6137f76633531a5817e3a9f268575c128249fb637e4f9e73fb"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-config-file" do
    url "https://files.pythonhosted.org/packages/13/09/dfee76b0d2600ae8bd65e9cc375b6de62f6ad5600616a78ee6209a9f17f3/click_config_file-0.6.0.tar.gz"
    sha256 "ded6ec1a73c41280727ec9c06031e929cdd8a5946bf0f99c0c3db3a71793d515"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/a0/0e/93e7c308611ff2ac3142dd5b1cef6bc02364affae21ba84342896470a868/humanize-4.3.0.tar.gz"
    sha256 "0dfac79fe8c1c0c734c14177b07b857bad9ae30dd50daa0a14e2c3d8054ee0c4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fe/58/30a4d3302f9bbd602c43385e7270fc3a9e8a665d07aafd6a4d4baa844739/oauthlib-3.2.1.tar.gz"
    sha256 "1565237372795bf6ee3e5aba5e2a85bd5a65d0e2aa5c628b9a97b7d7a0da3721"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/c1/c2/d8a40e5363fb01806870e444fc1d066282743292ff32a9da54af51ce36a2/tqdm-4.64.1.tar.gz"
    sha256 "5f4f682a004951c1b450bc753c710e9280c5746ce6ffedee253ddbcbf54cf1e4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "usage: twarc [-h] [--log LOG] [--consumer_key CONSUMER_KEY]",
                 shell_output("#{bin}/twarc -h").chomp.split("\n").first
  end
end
