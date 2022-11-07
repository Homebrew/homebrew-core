class Tvnamer < Formula
  include Language::Python::Virtualenv

  desc "Automatic TV episode file renamer that uses data from thetvdb.com"
  homepage "https://github.com/dbr/tvnamer"
  url "https://files.pythonhosted.org/packages/7e/07/688dc96a86cf212ffdb291d2f012bc4a41ee78324a2eda4c98f05f5e3062/tvnamer-3.0.4.tar.gz"
  sha256 "dc2ea8188df6ac56439343630466b874c57756dd0b2538dd8e7905048f425f04"
  license "Unlicense"
  revision 2
  head "https://github.com/dbr/tvnamer.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44bcd455f8e36aa40ab7e0d5a300752264520b18ffd739eefca7d760c2ae105a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea4e7305d39b4960cf73fbf8fa9767aad646e83bb9d4cb36ae4271aa2b2eba94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44270b65aab543ed23b67d0e803ee8ed12b1053198fde809e8d09de945d91084"
    sha256 cellar: :any_skip_relocation, monterey:       "94be19c99705477fdd53b7f05f1b4c00ea511897f522c5e32590c4a4fb86a98e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1a6f5ec60abccddfb3ab65731e70c579cee559d103a22609c8e002a71157412"
    sha256 cellar: :any_skip_relocation, catalina:       "a4d03019f5357d1c4303d5a1efb3da25107ff401ed3051340173926b1177733b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e6cb2069465bae0cb33abe999cd1e2092394aab991d634adb2dea3bae6282dc"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/0c/d4/bdc22aad6979ceeea2638297f213108aeb5e25c7b103fa02e4acbe43992e/requests-cache-0.5.2.tar.gz"
    sha256 "813023269686045f8e01e2289cc1e7e9ae5ab22ddd1e2849a9093ab3ab7270eb"
  end

  resource "tvdb_api" do
    url "https://files.pythonhosted.org/packages/a9/66/7f9c6737be8524815a02dd2edd3a24718fa786614573104342eae8d2d08b/tvdb_api-3.1.0.tar.gz"
    sha256 "f63f6db99441bb202368d44aaabc956acc4202b18fc343a66bf724383ee1f563"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    raw_file = testpath/"brass.eye.s01e01.avi"
    expected_file = testpath/"Brass Eye - [01x01] - Animals.avi"
    touch raw_file
    system bin/"tvnamer", "-b", raw_file
    assert_predicate expected_file, :exist?
  end
end
