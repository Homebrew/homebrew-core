class Rockcraft < Formula
  include Language::Python::Virtualenv

  desc "Tool to create OCI images using the language from Snapcraft and Charmcraft"
  homepage "https://documentation.ubuntu.com/rockcraft/"
  # git checkout needed for setuptools-scm
  url "https://github.com/canonical/rockcraft.git",
      tag:      "1.16.0",
      revision: "700add86859077a9283d1d5a876cc4c1fdd532ea"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/canonical/rockcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "36054f423876614ebfa092aebbadadddab6aa94b5bb8b3bd8958c29b58ef668d"
    sha256 cellar: :any,                 arm64_sequoia: "dab84f69f2bcab09b3f00294d56297bbe0091b95251ab390ef80164bf128b8d5"
    sha256 cellar: :any,                 arm64_sonoma:  "6c44cf7d0762375091699b6b23561ecdcfcb9b0e03a8c171709202df44ff4b93"
    sha256 cellar: :any,                 sonoma:        "aa24e9811229afc51efa4d07c7d13ef6ab6b260e84cc979720ce07339256b78e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa51e90b674c06fdd3a9d31c64fa60ab86d55be034e9f64bacad325883070167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a198c73d33d70a5857c419a9cb91b35762f6b941b4173ea505f57aedcf5e1979"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography"
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "lxc"
  depends_on "pydantic" => :no_linkage
  depends_on "pygit2" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[certifi cryptography pydantic pygit2],
                extra_packages:   %w[jeepney secretstorage]

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/c4/cf/85379f13b76f3a69bca86b60237978af17d6aa0bc5998978c3b8cf05abb2/boolean_py-5.0.tar.gz"
    sha256 "60cbc4bad079753721d32649545505362c754e121570ada4658b852a3a318d95"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "craft-application" do
    url "https://files.pythonhosted.org/packages/f6/f8/53b68f2b70385d31b5d6f8e147d70bedeece67076d7b06bc91d908669ac0/craft_application-6.0.1.tar.gz"
    sha256 "291249a0f24e811c37175bbc9a23c7f4a37b3dba9db01a5dcd35d21253ce8db9"
  end

  resource "craft-archives" do
    url "https://files.pythonhosted.org/packages/41/4c/63ce5d6c91b4b269f862460392bd70fd0594f7902641b5d0bc82aa3f1c41/craft_archives-2.2.0.tar.gz"
    sha256 "0bfd6dc3c2710605b97292df952032af24bf94ebf2f284f355d70f1bb2e3fe20"
  end

  resource "craft-cli" do
    url "https://files.pythonhosted.org/packages/35/0a/f1612fe57295b6a69ff256dbd0826b90f70b27dda90988f972fa6f8968cc/craft_cli-3.2.0.tar.gz"
    sha256 "557345bf1d82e93d6525f35837ddd2b216de4152f5572306ec59d805231d348b"
  end

  resource "craft-grammar" do
    url "https://files.pythonhosted.org/packages/c7/35/584fc928bffd1346c4b9c55170cbe4c09f89ec185d0d9d7e2626f876e80d/craft_grammar-2.3.0.tar.gz"
    sha256 "0b7ae3aa595f0f3d1f82ed2e696c99b35283c18a60c7a68840bc185bd123e4d8"
  end

  resource "craft-parts" do
    url "https://files.pythonhosted.org/packages/ca/80/5d2ab6748840460d0d96ae95cf56be6d6c15c57266e4f2ced34ac0f8c44a/craft_parts-2.28.0.tar.gz"
    sha256 "8de965c14272776c23e1a8836178448bf3dc9baa713a4bd2d68fe686885b093a"
  end

  resource "craft-platforms" do
    url "https://files.pythonhosted.org/packages/44/78/f2c3ef342c9e9fee0127516aee113a28c487a999d35ce4aa944a58bd5939/craft_platforms-0.10.0.tar.gz"
    sha256 "85b8630c0f7436b0832466c1dba8deb040502fdadc1d225fbed15d1e1e38f729"
  end

  resource "craft-providers" do
    url "https://files.pythonhosted.org/packages/7f/c5/2249f683065b65c272e727f239cfb0f884e8fdc5bbfa06b0b2a463a57c83/craft_providers-3.2.0.tar.gz"
    sha256 "5637ae2865b813e3580d660eb4e36bf404a7b6fba28a42afdb94731d8a9305ec"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "distro-support" do
    url "https://files.pythonhosted.org/packages/91/9f/530d03c3d7172f787949af55768d088a341e52974c03ce26142693375de1/distro_support-2025.12.16.tar.gz"
    sha256 "95d93375983a68cd749e7ae9d434a22ab7d5b6f515fbed52541ecc9457296946"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/52/77/6653db69c1f7ecfe5e3f9726fdadc981794656fcd7d98c4209fecfea9993/httplib2-0.31.0.tar.gz"
    sha256 "ac7ab497c50975147d4f7b1ade44becc7df2f8954d42b38b3d69c515f531135c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "launchpadlib" do
    url "https://files.pythonhosted.org/packages/30/ec/e659321733decaafe95d4cf964ce360b153de48c5725d5f27cefe97bf5f8/launchpadlib-2.1.0.tar.gz"
    sha256 "b4c25890bb75050d54c08123d2733156b78a59a2555f5461f69b0e44cd91242f"
  end

  resource "lazr-restfulclient" do
    url "https://files.pythonhosted.org/packages/ea/a3/45d80620a048c6f5d1acecbc244f00e65989914bca370a9179e3612aeec8/lazr.restfulclient-0.14.6.tar.gz"
    sha256 "43f12a1d3948463b1462038c47b429dcb5e42e0ba7f2e16511b02ba5d2adffdb"
  end

  resource "lazr-uri" do
    url "https://files.pythonhosted.org/packages/58/53/de9135d731a077b1b4a30672720870abdb62577f18b1f323c87e6e61b96c/lazr_uri-1.0.7.tar.gz"
    sha256 "ed0cf6f333e450114752afb1ce0c299c36ac4b109063eb50354c4f87f825a3ee"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/40/71/d89bb0e71b1415453980fd32315f2a037aad9f7f70f695c7cec7035feb13/license_expression-30.4.4.tar.gz"
    sha256 "73448f0aacd8d0808895bdc4b2c8e01a8d67646e4188f887375398c761f340fd"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/36/86/b585f53236dec60aba864e050778b25045f857e17f6e5ea0ae95fe80edd2/overrides-7.7.0.tar.gz"
    sha256 "55158fa3d93b98cc75299b1e67078ad9003ca27945c76162c1c0766d6f91820a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  resource "pylxd" do
    url "https://files.pythonhosted.org/packages/86/0e/a5aaf3a49e75d80be59ded39a69c70285de0027598a820d99402d73457a6/pylxd-2.3.7.tar.gz"
    sha256 "3ceb967d8c599ffecebdd8355da7074d71e85fd8eeaefb6cbd474c6449cdfbfb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/33/c1/1d9de9aeaa1b89b0186e5fe23294ff6517fce1bc69149185577cd31016b2/pyparsing-3.3.1.tar.gz"
    sha256 "47fad0f17ac1e2cad3de3b458570fbc9b03560aa029ed5e16ee5554da9a2251c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-debian" do
    url "https://files.pythonhosted.org/packages/bf/4b/3c4cf635311b6203f17c2d693dc15e898969983dd3f729bee3c428aa60d4/python-debian-1.0.1.tar.gz"
    sha256 "3ada9b83a3d671b58081782c0969cffa0102f6ce433fbbc7cf21275b8b5cc771"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "requests-unixsocket2" do
    url "https://files.pythonhosted.org/packages/12/04/e5c07a329a0087f8a342231b6e054d83279c17ccc81da5aa18071c8ea75e/requests_unixsocket2-1.0.1.tar.gz"
    sha256 "87953038ae42befb6efbdf504d6dda2554a0b0d13b65e42f7319793b5527a303"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/72/d1/d3159231aec234a59dd7d601e9dd9fe96f3afff15efd33c1070019b26132/semver-3.0.4.tar.gz"
    sha256 "afc7d8c584a5ed0a11033af086e8af226a9c0b206f313e0301f8dd7b6b589602"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/8d/d2/ec1acaaff45caed5c2dedb33b67055ba9d4e96b091094df90762e60135fe/setuptools-80.8.0.tar.gz"
    sha256 "49f7af965996f26d43c8ae34539c8d99c5042fbff34302ea151eaa9c207cd257"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "snap-helpers" do
    url "https://files.pythonhosted.org/packages/50/2a/221ab0a9c0200065bdd8a5d2b131997e3e19ce81832fdf8138a7f5247216/snap-helpers-0.4.2.tar.gz"
    sha256 "ef3b8621e331bb71afe27e54ef742a7dd2edd9e8026afac285beb42109c8b9a9"
  end

  resource "spdx" do
    url "https://files.pythonhosted.org/packages/2d/bc/a405bbad6eabd62538ec047a3ab2294142606e516c676eddbefade70c375/spdx-2.5.1.tar.gz"
    sha256 "4d734b0bcc6c9ec34d238621633bd2ffa5b42773b055cbe0b18e925e1ee039b9"
  end

  resource "spdx-lookup" do
    url "https://files.pythonhosted.org/packages/2f/ea/aad16afb2365fd84536a1dd42be115bb7079f56c3bc50c70257a3f4cfb94/spdx-lookup-0.3.3.tar.gz"
    sha256 "d41e08ecebb9a6720e8b1dff029b43802c9d929e06dcb648aea58ba93d8f125e"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "wadllib" do
    url "https://files.pythonhosted.org/packages/da/54/82866d8c2bf602ed9df52c8f8b7a45e94f8c2441b3d1e9e46d34f0e3270f/wadllib-2.0.0.tar.gz"
    sha256 "1edbaf23e4fa34fea70c9b380baa2a139b1086ae489ebcccc4b3b65fc9737427"
  end

  resource "ws4py" do
    url "https://files.pythonhosted.org/packages/cb/55/dd8a5e1f975d1549494fe8692fc272602f17e475fe70de910cdd53aec902/ws4py-0.6.0.tar.gz"
    sha256 "9f87b19b773f0a0744a38f3afa36a803286dd3197f0bb35d9b75293ec7002d19"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"

    # Test that rockcraft init creates a valid project file
    system bin/"rockcraft", "init"
    assert_path_exists testpath/"rockcraft.yaml"

    # Verify the generated file contains expected content
    assert_match "name:", (testpath/"rockcraft.yaml").read
  end
end
