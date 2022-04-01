class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/31/74/0e3b7af9c5f1b2f3b51d0f38b131a1e8cc6ec08c1da01f759b3be6985272/twarc-2.10.2.tar.gz"
  sha256 "c6ae32a94d5cd51f2f6991f4e540582263d24bb685933181b0f6e846321396f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e17f2b29ecc3883a86e8c2ed9ee39775230fd1d6c32fa6361e27fe974e0d8bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f3e2cef7baaa53ca2d603028093b4da52c1e4562b50ec64413123d3e03e55b0"
    sha256 cellar: :any_skip_relocation, monterey:       "728965e66b70d4ba1005b009d2b694ec5be325935dacb5ce1c7e21f01bb8b0b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c434403932d1cef0fb9378d9bd33b0d3455948ce7026063e29d4837c75482ecd"
    sha256 cellar: :any_skip_relocation, catalina:       "f45793aead9ac36fca4206fd7ae7ce78a3334502b2879f5585ae204a57ca7b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a47a9987fb1fe63d8c91dddeaed5e05dfd313943e6e98d838212d9fe0b4ad87"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/42/e1/4cb2d3a2416bcd871ac93f12b5616f7755a6800bccae05e5a99d3673eb69/click-8.1.2.tar.gz"
    sha256 "479707fe14d9ec9a0757618b7a100a0ae4c4e236fac5b7f80ca68028141a1a72"
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
    url "https://files.pythonhosted.org/packages/db/08/dbe660b435f7dcc9cd78c928cabba90e3088c10b2a90843c102cc3671154/humanize-4.0.0.tar.gz"
    sha256 "ee1f872fdfc7d2ef4a28d4f80ddde9f96d36955b5d6b0dac4bdeb99502bddb00"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6e/7e/a43cec8b2df28b6494a865324f0ac4be213cb2edcf1e2a717547a93279b0/oauthlib-3.2.0.tar.gz"
    sha256 "23a8208d75b902797ea29fd31fa80a15ed9dc2c6c16fe73f5d346f83f6fa27a2"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3c/77/e75fb048907ccc065030bf7d9d2d1441247e4e234dbfceb5466207190962/tqdm-4.63.1.tar.gz"
    sha256 "4230a49119a416c88cc47d0d2d32d5d90f1a282d5e497d49801950704e49863d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "usage: twarc [-h] [--log LOG] [--consumer_key CONSUMER_KEY]",
                 shell_output("#{bin}/twarc -h").chomp.split("\n").first
  end
end
