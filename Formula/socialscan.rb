class Socialscan < Formula
  include Language::Python::Virtualenv

  desc "Check email address and username availability on online platforms"
  homepage "https://github.com/iojw/socialscan"
  url "https://files.pythonhosted.org/packages/29/92/f542e98b8defae23ff45477f8eee750adadb6ab74f7acb3ab73e1e0c8784/socialscan-1.1.4.tar.gz"
  sha256 "7fd6c0babdaf8d1c67ab7bfdd215d669fb267f9f11b20b30749404929ccca38c"

  depends_on "python"

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/00/94/f9fa18e8d7124d7850a5715a0b9c0584f7b9375d331d35e157cee50f27cc/aiohttp-3.6.2.tar.gz"
    sha256 "259ab809ff0727d0e834ac5e8a283dc5e3e0ecc30c4d80b3cd17a4139ce1f326"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/a1/78/aae1545aba6e87e23ecab8d212b58bb70e72164b67eb090b81bb17ad38e3/async-timeout-3.0.1.tar.gz"
    sha256 "0c3c816a028d47f659d6ff5c745cb2acf1f966da1fe5c19c77a70282b25f4c5f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/98/c3/2c227e66b5e896e15ccdae2e00bbc69aa46e9a8ce8869cc5fa96310bf612/attrs-19.3.0.tar.gz"
    sha256 "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/82/75/f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12d/colorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/b6/22/ae21cedaa0e6d35e84e8ab57700dcf3d4609421ebe113e1aaafc468eec42/multidict-4.7.4.tar.gz"
    sha256 "d7d428488c67b09b26928950a395e41cc72bb9c3d5abfe9f0521940ee4f796d4"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/cd/22/f15bb3c0a2810da0e825d193fb76d782015d82c676c4f682a957814926d7/tqdm-4.41.1.tar.gz"
    sha256 "4789ccbb6fc122b5a6a85d512e4e41fc5acad77216533a6f2b8ce51e0f265c23"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/d6/67/6e2507586eb1cfa6d55540845b0cd05b4b77c414f6bca8b00b45483b976e/yarl-1.4.2.tar.gz"
    sha256 "58cd9c469eced558cd81aa3f484b2924e8897049e06889e8ff2510435b7ef74b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"socialscan", "--help"
  end
end
