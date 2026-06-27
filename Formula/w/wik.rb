class Wik < Formula
  include Language::Python::Virtualenv

  desc "View Wikipedia pages from your terminal"
  homepage "https://github.com/yashsinghcodes/wik"
  url "https://files.pythonhosted.org/packages/ee/93/4a221efc5995f8ee24731a145277de0beb68477f30cdf76954355cd6c62f/wik-2.0.1.tar.gz"
  sha256 "a12141d06967a7c21dee62fdd6d6086e4cb3f14ea18fae4aa294e39dfd5f23e2"
  license "MIT"
  revision 2
  head "https://github.com/yashsinghcodes/wik.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea17fb6fc93076490adaf60329fecd3845a4e46d6ee30c9eefbeddfabd5352e9"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/24/36/7180e7f077c38108945dbbdf60fe04db681c3feb6e96419f8c6dc8723741/requests-2.34.1.tar.gz"
    sha256 "0fc5669f2b69704449fe1552360bd2a73a54512dfd03e65529157f1513322beb"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/7b/ae/2d9c981590ed9999a0d91755b47fc74f74de286b0f5cee14c9269041e6c4/soupsieve-2.8.3.tar.gz"
    sha256 "3267f1eeea4251fb42728b6dfb746edc9acaffc4a45b27e19450b676586e8349"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Homebrew is a free and open-source software package management system",
      shell_output("#{bin}/wik --info 'Homebrew (package manager)'")
  end
end
