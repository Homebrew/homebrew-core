class Tvnamer < Formula
  include Language::Python::Virtualenv

  desc "Automatic TV episode file renamer that uses data from thetvdb.com"
  homepage "https://github.com/dbr/tvnamer"
  url "https://files.pythonhosted.org/packages/7e/07/688dc96a86cf212ffdb291d2f012bc4a41ee78324a2eda4c98f05f5e3062/tvnamer-3.0.4.tar.gz"
  sha256 "dc2ea8188df6ac56439343630466b874c57756dd0b2538dd8e7905048f425f04"
  license "Unlicense"
  revision 8
  head "https://github.com/dbr/tvnamer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2052694f5a9c996975e767709d0e9e46217904a11729bc3f07b27f2ea6ce40de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c87efde56f3579b46e9134aa1bf0d0d6043e590980c8648502285287625dfdd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c87efde56f3579b46e9134aa1bf0d0d6043e590980c8648502285287625dfdd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1038d8194aa675271b4fdd35d5fadc2fd9e553e18fc7397579306aaa0b6c17f"
    sha256 cellar: :any_skip_relocation, ventura:        "f1038d8194aa675271b4fdd35d5fadc2fd9e553e18fc7397579306aaa0b6c17f"
    sha256 cellar: :any_skip_relocation, monterey:       "018758f7067a788b064c080b7b43b7e50459a46ab1f8680318f0dab5dde12d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed381ee0b253ea88247a0ac8b7af69ae1451c5cdb1b6f67d65fe2b377a8600e1"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-cache" do
    url "https://files.pythonhosted.org/packages/0c/d4/bdc22aad6979ceeea2638297f213108aeb5e25c7b103fa02e4acbe43992e/requests-cache-0.5.2.tar.gz"
    sha256 "813023269686045f8e01e2289cc1e7e9ae5ab22ddd1e2849a9093ab3ab7270eb"
  end

  resource "tvdb-api" do
    url "https://files.pythonhosted.org/packages/a9/66/7f9c6737be8524815a02dd2edd3a24718fa786614573104342eae8d2d08b/tvdb_api-3.1.0.tar.gz"
    sha256 "f63f6db99441bb202368d44aaabc956acc4202b18fc343a66bf724383ee1f563"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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
