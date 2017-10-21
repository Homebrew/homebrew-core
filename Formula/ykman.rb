class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration."
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://developers.yubico.com/yubikey-manager/Releases/yubikey-manager-0.4.5.tar.gz"
  sha256 "d91f5b549b23bfc6c04d9446b9ced6c6f80aac702b26a1fa4d1b8df5eb9a36d8"

  bottle do
    cellar :any
    sha256 "a0bb5c97a42c384d4d838cd34f7996f5a4d44a542a2fb1833538cf39ea9bdcea" => :high_sierra
    sha256 "b36a3d075b695773d351118fe10443208936aeb2e648a60cd847182a9a876977" => :sierra
    sha256 "3d345880c5a2f005d968460c9e03b9724be65996ddf933eabe2d875c3172c11e" => :el_capitan
  end

  head do
    url "https://github.com/Yubico/yubikey-manager.git"
  end

  depends_on "swig" => :build
  depends_on "ykpers"
  depends_on "libu2f-host"
  depends_on "libusb"
  depends_on "openssl"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/67/14/5d66588868c4304f804ebaff9397255f6ec5559e46724c2496e0f26e68d6/asn1crypto-0.22.0.tar.gz"
    sha256 "cbbadd640d3165ab24b06ef25d1dca09a3441611ac15f6a6b452474fdf0aed1a"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/5b/b9/790f8eafcdab455bcd3bd908161f802c9ce5adbf702a83aa7712fcc345b7/cffi-1.10.0.tar.gz"
    sha256 "b3b02911eb1f6ada203b0763ba924234629b51586f72a21faacc638269f4ced5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9c/1a/0fc8cffb04582f9ffca61b15b0681cf2e8588438e55f61403eb9880bd8e0/cryptography-2.0.3.tar.gz"
    sha256 "d04bb2425086c3fe86f7bc48915290b13e798497839fbb18ab7f6dffcf98cc3a"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/b0/9e/7088f6165c40c46416aff434eb806c1d64ad6ec6dbc201f5ad4d0484704e/pyOpenSSL-17.2.0.tar.gz"
    sha256 "5d617ce36b07c51f330aa63b83bf7f25c40a0e95958876d54d1982f8c91b4834"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/96/fa/b1dd66639f88ddc696523bbe7da64e2dd1b7033da935f6db9862e4d4bfa8/pyscard-1.9.6.tar.gz"
    sha256 "6e28143c623e2b34200d2fa9178dbc80a39b9c068b693b2e6527cdae784c6c12"
  end

  resource "pyusb" do
    url "https://files.pythonhosted.org/packages/8a/19/66fb48a4905e472f5dfeda3a1bafac369fbf6d6fc5cf55b780864962652d/PyUSB-1.0.0.tar.gz"
    sha256 "5b34ffa74ac34f330bff949c94ee00ec4a9d147234db17ee2eed2a67c0275368"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # YubiKey Manager (ykman) version: 0.4.5
    assert_match "0.4.5", shell_output("#{bin}/ykman --version")
  end
end
