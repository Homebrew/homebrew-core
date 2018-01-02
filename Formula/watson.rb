class Watson < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to track (your) time"
  homepage "https://tailordev.github.io/Watson/"
  revision 1
  head "https://github.com/TailorDev/Watson.git"

  stable do
    url "https://files.pythonhosted.org/packages/37/49/f1ee677017cd8343d5ef3a6c5c449f4763d26f4ba5cb3aa1b38769133ee7/td-watson-1.5.2.tar.gz"
    sha256 "6e03d44a9278807fe5245e9ed0943f13ffb88e11249a02655c84cb86260b27c8"

    # Fix "Unordered types are not allowed" error for install_requires
    # Upstream commit from 9 Dec 2017 "Fix setup.py and flake8 complaint"
    patch do
      url "https://github.com/TailorDev/Watson/commit/f5760c7.patch?full_index=1"
      sha256 "63c51040e7e4b0229c9bccd74ca88822fb38e7cdb17056348b0aac8ec9b02298"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6d0a2d0c27ba00f699f5ed3305104ee98b5a62a0e24ed235fa4386ee7d147786" => :high_sierra
    sha256 "b73f589ea7a6c88f8e75b44b0c5dfe39d43a6e2bf7e8f04ac865706fb2b605c1" => :sierra
    sha256 "a88d5581565c2bcc025fff52006286146d2bd1326c6dc382a7cfb160ca30b947" => :el_capitan
    sha256 "6b2461f85332a77ec5bd22abccd83fe1a8e13d3c9ac0a0ee8e1dd1a0d7e1382c" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/54/db/76459c4dd3561bbe682619a5c576ff30c42e37c2e01900ed30a501957150/arrow-0.10.0.tar.gz"
    sha256 "805906f09445afc1f0fc80187db8fe07670e3b25cdafa09b8d8ac264a8c0c722"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/20/d0/3f7a84b0c5b89e94abbd073a5f00c7176089f526edb056686751d5064cbd/certifi-2017.7.27.1.tar.gz"
    sha256 "40523d2efb60523e113b44602298f0960e900388cf3bb6043f645cf57ea9e3f5"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/07/2e/81fdfdfac91cf3cb2518fb149ac67caf0e081b485eab68e9aee63396f7e8/requests-2.18.2.tar.gz"
    sha256 "5b26fcc5e72757a867e4d562333f841eddcef93548908a1bb1a9207260618da9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "watson.completion" => "watson"
    zsh_completion.install "watson.zsh-completion" => "_watson"
  end

  test do
    system "#{bin}/watson", "start", "foo", "+bar"
    system "#{bin}/watson", "status"
    system "#{bin}/watson", "stop"
    system "#{bin}/watson", "log"
  end
end
