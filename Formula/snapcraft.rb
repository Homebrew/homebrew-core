class Snapcraft < Formula
  include Language::Python::Virtualenv

  desc "Package any app for every Linux desktop, server, cloud or device"
  homepage "https://snapcraft.io/"
  url "https://github.com/snapcore/snapcraft/archive/3.7.2.tar.gz"
  sha256 "df11f0ba80efff5fee6c397d38c4aa8a7816b0b1629c4f0e84c3776520340ffe"

  bottle do
    cellar :any
    sha256 "f0c6d4c0571821bffc5ec388c09e11511a4b8352d606553f155d08608502fa1d" => :mojave
    sha256 "bbad8eab86b13c770c6ed3a0e52342d2396d1653f2bebb7a7b45985ffe34fd40" => :high_sierra
    sha256 "adff1c1ce0876ee58b6b0c7d9b9af78d0614f06d2e21ed0800f8dcb6a7ff8943" => :sierra
  end

  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "lxc"
  depends_on "python"
  depends_on "squashfs"
  depends_on "xdelta"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/15/d4/2f888fc463d516ff7bf2379a4e9a552fef7f22a94147655d9b1097108248/certifi-2018.1.18.tar.gz"
    sha256 "edbc3f203427eef571f79a7692bb160a2b0f7ccaa31953e99bd17e307cf63f7d"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/10/f7/3b302ff34045f25065091d40e074479d6893882faef135c96f181a57ed06/cffi-1.11.4.tar.gz"
    sha256 "df9083a992b17a28cd4251a3f5c879e0198bb26c9e808c4647e0a18739f1d11d"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/7c/69/c2ce7e91c89dc073eb1aa74c0621c3eefbffe8216b3f9af9d3885265c01c/configparser-3.5.0.tar.gz"
    sha256 "5308b47021bc2340965c371f0f058cc6971a04502638d4244225c49d80db273a"
  end

  resource "cookies" do
    url "https://files.pythonhosted.org/packages/f3/95/b66a0ca09c5ec9509d8729e0510e4b078d2451c5e33f47bd6fc33c01517c/cookies-2.2.1.tar.gz"
    sha256 "d6b698788cae4cfa4e62ef8643a9ca332b79bd96cb314294b864ae8d7eb3ee8e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/b9/171dbb07e18c6346090a37f03c7e74410a1a56123f847efed59af260a298/jsonschema-2.6.0.tar.gz"
    sha256 "6ff5f3180870836cae40f06fa10419f557208175f13ad7bc26caa77beb1f6e02"
  end

  resource "libnacl" do
    url "https://files.pythonhosted.org/packages/ef/4a/5756e25deb82b690982547f8ed61fbc1008e6931b49f8f3a0b6ad8866b10/libnacl-1.5.2.tar.gz"
    sha256 "c58390b0d191db948fc9ab681f07fdfce2a573cd012356bada47d56795d00ee2"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/81/80/1df9176f9021c588155d0c7a86f1e963cec77fefa31934bc380acb0dbd5e/pbr-5.4.2.tar.gz"
    sha256 "9b321c204a88d8ab5082699469f52cc94c5da45c51f114113d01b3d993c24cdf"
  end

  resource "petname" do
    url "https://files.pythonhosted.org/packages/b8/6c/3b5c55a6632771b6a3ffc46ebb1d01bd7d2ca7ce3b44ebfd3c6ceeb9a6f6/petname-2.2.tar.gz"
    sha256 "be1da50a6aa01e39840e9a4b79b527a333b256733cb681f52669c08df7819ace"
  end

  resource "pylxd" do
    url "https://files.pythonhosted.org/packages/42/4f/39c3614b91f0b9e8ba757d2bacb13b356b5c8d0f6be1fdebbc2b795ae831/pylxd-2.2.9.tar.gz"
    sha256 "2bd5ce9c258d495312cf9f9e1b392ad6d1d40b7dd2a35a789e2cceb2bef184cc"
  end

  resource "progressbar33" do
    url "https://files.pythonhosted.org/packages/71/fc/7c8e01f41a6e671d7b11be470eeb3d15339c75ce5559935f3f55890eec6b/progressbar33-2.4.tar.gz"
    sha256 "51fe0d9b3b4023db2f983eeccdfc8c9846b84db8443b9bee002c7f58f4376eff"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/ba/78/d4a186a2e38731286c99dc3e3ca8123b6f55cf2e28608e8daf2d84b65494/pyelftools-0.24.tar.gz"
    sha256 "e9dd97d685a5b96b88a988dabadb88e5a539b64cd7d7927fac9a7368dc4c459c"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/38/a8/f98dfe2aca2301e8b8899166554bde1437c7110579c372581e1225ab0c81/pymacaroons-0.12.0.tar.gz"
    sha256 "e5fd325cfa845c88f3cb8b5c07a5363e7032fa5cbdb7b48ae0b50445c32167bf"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/08/19/cf56e60efd122fa6d2228118a9b345455b13ffe16a14be81d025b03b261f/PyNaCl-1.2.1.tar.gz"
    sha256 "e0d38fa0a75f65f556fb912f2c6790d1fa29b7dd27a1d9cc5591b281321eaaa9"
  end

  resource "pysha3" do
    url "https://files.pythonhosted.org/packages/73/bf/978d424ac6c9076d73b8fdc8ab8ad46f98af0c34669d736b1d83c758afee/pysha3-1.0.2.tar.gz"
    sha256 "fe988e73f2ce6d947220624f04d467faf05f1bbdbc64b0a201296bb3af92739e"
  end

  resource "python-debian" do
    url "https://files.pythonhosted.org/packages/54/bf/d59ca16512ee6d740f2272ec8eeab47517bef3043eefbfe47391493cb567/python-debian-0.1.31.tar.gz"
    sha256 "21465ccb8a4cb2942f15e74b6c9b92caff5188365e22ab4a0dcc778b90f28479"
  end

  resource "pymacaroons-pynacl" do
    url "https://github.com/matrix-org/pymacaroons/archive/v0.9.3.tar.gz"
    sha256 "871399c4dc1dfab7a435df2d5f2954cbba51d275ca2e93a96abb8b35d348fe5a"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/26/28/ee953bd2c030ae5a9e9a0ff68e5912bd90ee50ae766871151cd2572ca570/pyxdg-0.25.tar.gz"
    sha256 "81e883e0b9517d624e8b0499eb267b82a815c0b7146d5269f364988ae031279d"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "raven" do
    url "https://files.pythonhosted.org/packages/d7/54/7d199f893a0ac01f8df9b7ec39c0f3ac19146e78b33401b1f4984c9d3583/raven-6.7.0.tar.gz"
    sha256 "f908e9b39f02580e7f822030d119ed3b2e8d32300a2fec6373e5827d588bbae7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/86/f9/e80fa23edca6c554f1994040064760c12b51daff54b55f9e379e899cd3d4/requests-toolbelt-0.8.0.tar.gz"
    sha256 "f6a531936c6fa4c6cfce1b9c10d5c4f498d16528d2a54a22ca00011205a187b5"
  end

  resource "requests-unixsocket" do
    url "https://files.pythonhosted.org/packages/f3/94/67d781fb32afbee0fffa0ad9e16ad0491f1a9c303e14790ae4e18f11be19/requests-unixsocket-0.1.5.tar.gz"
    sha256 "a91bc0138f61fb3396de6358fa81e2cd069a150ade5111f869df01d8bc9d294c"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/2e/18/20a4a96365d42f02363ec0062b70ff93f7b6639e569fd0cb174209d59a3a/responses-0.8.1.tar.gz"
    sha256 "a64029dbc6bed7133e2c971ee52153f30e779434ad55a5abf40322bcff91d029"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/0d/3f/3a16847fe5c010110a8f54dd8fe7b091b4e22922def374fe1cce9c1cb7e9/simplejson-3.13.2.tar.gz"
    sha256 "4c4ecf20e054716cc1e5a81cadc44d3f4027108d8dd0861d8b1e3bd7a32d4f0a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/12/c2/11d6845db5edf1295bc08b2f488cf5937806586afe42936c3f34c097ebdc/tabulate-0.8.2.tar.gz"
    sha256 "e4ca13f26d0a6be2a2915428dc21e732f1e44dad7f76d7030b2ef1ec251cf7f2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"]="en_US.UTF-8"
    system "#{bin}/snapcraft", "--version"
    system "#{bin}/snapcraft", "--help"
    system "#{bin}/snapcraft", "init"
    assert_predicate testpath/"snap/snapcraft.yaml", :exist?
  end
end
