class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/60/8b/bb674291306e702b6909d88839e2430112ddae5f7e7c65f3985c8edf6e83/twarc-2.10.0.tar.gz"
  sha256 "5dbab8d2efe5ba4d512ab6b2b41ef11fa8e3c155cb96806dae2df80b44accf19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a24293ac5c6073da36f85c31e98e9a1dd81d5f22af0d9a59b5b8fde411413d4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b458a23e4bed460d0300daab645201a36174f092e40f908f804a25daf438bf6"
    sha256 cellar: :any_skip_relocation, monterey:       "4d61560acc8e5cfc25d23550e3fd15523a1e3a8b69b221e5fad6167d2920eea8"
    sha256 cellar: :any_skip_relocation, big_sur:        "99198f8fb01e7807aaa9b43fa25b828504c8b86750dcda6cdb77cd3758806b9d"
    sha256 cellar: :any_skip_relocation, catalina:       "5c50f75b7a3e2bcb543cee067b832c93170da91df03924c6824cf844af3ee918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8be80ac3eb5080fbc84d025491dd1cbbb7d2f2b4ea28be8bf18ca3b3bcc74757"
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
    url "https://files.pythonhosted.org/packages/dd/cf/706c1ad49ab26abed0b77a2f867984c1341ed7387b8030a6aa914e2942a0/click-8.0.4.tar.gz"
    sha256 "8458d7b1287c5fb128c90e23381cf99dcde74beaf6c7ff6384ce84d6fe090adb"
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
    url "https://files.pythonhosted.org/packages/cb/a5/803a55cae355bc2402492c6a1c23dc08117844e4a1c3a293b0ea19bca6fa/tqdm-4.63.0.tar.gz"
    sha256 "1d9835ede8e394bb8c9dcbffbca02d717217113adc679236873eeaac5bc0b3cd"
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
