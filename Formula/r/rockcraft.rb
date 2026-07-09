class Rockcraft < Formula
  include Language::Python::Virtualenv

  desc "Tool to create OCI images using the language from Snapcraft and Charmcraft"
  homepage "https://documentation.ubuntu.com/rockcraft/"
  # git checkout needed for setuptools-scm
  url "https://github.com/canonical/rockcraft.git",
      tag:      "1.19.2",
      revision: "bd45d512b78b76fc450caf27419954cdd95dea12"
  license "GPL-3.0-only"
  head "https://github.com/canonical/rockcraft.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6e322310ba1ad53546269a2d01ca42b7acf18e50090f1f913c59ae62f8ed260c"
    sha256 cellar: :any, arm64_sequoia: "03a88b09aecafdd3eae9a91aad3e6dcb3245065ecb12ab9b20ce3d053c1bb57f"
    sha256 cellar: :any, arm64_sonoma:  "377cea08ca8bfc0bd1eeb8867721ff1e9425ff8b9c010c2987d061d1fc6e6433"
    sha256 cellar: :any, sonoma:        "8505a5a93b60c1a82497a0935d290477f65b240482585b0a9efd1a22f22985dc"
    sha256 cellar: :any, arm64_linux:   "6e00aa658255f44bab9b7eeb22f6af540ef14bf247832a496621b13edce82c86"
    sha256 cellar: :any, x86_64_linux:  "6f69cce756bee5f5a725fcb1b23a8ee5c1aa81e1f48a192eaa81e4bc06475bba"
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
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "craft-application" do
    url "https://files.pythonhosted.org/packages/b5/82/f364723d620fd5e96e2d1a2a4e0f975113f3be4650923cd028ae33f1c1a0/craft_application-7.0.0.tar.gz"
    sha256 "f341e05992b8f64f1d86ec927e3bb66ec72abcecdbca02117a99fd3b4c093715"
  end

  resource "craft-archives" do
    url "https://files.pythonhosted.org/packages/41/4c/63ce5d6c91b4b269f862460392bd70fd0594f7902641b5d0bc82aa3f1c41/craft_archives-2.2.0.tar.gz"
    sha256 "0bfd6dc3c2710605b97292df952032af24bf94ebf2f284f355d70f1bb2e3fe20"
  end

  resource "craft-cli" do
    url "https://files.pythonhosted.org/packages/b2/97/55e3a42aed3c8ee408dca292c7736080161d6bcfd6d21a8374b74be90f63/craft_cli-3.4.1.tar.gz"
    sha256 "e4396695e89f15fbd06255a78b38a362006cd711266d926c2b6cd2a546af61a5"
  end

  resource "craft-grammar" do
    url "https://files.pythonhosted.org/packages/c7/35/584fc928bffd1346c4b9c55170cbe4c09f89ec185d0d9d7e2626f876e80d/craft_grammar-2.3.0.tar.gz"
    sha256 "0b7ae3aa595f0f3d1f82ed2e696c99b35283c18a60c7a68840bc185bd123e4d8"
  end

  resource "craft-parts" do
    url "https://files.pythonhosted.org/packages/25/17/dad4f52f6619abca9a9ecd66a79d816f0cee99cebcd300abaf8bc736d5b0/craft_parts-2.33.1.tar.gz"
    sha256 "50c4dc1ef4a062f1a500c2718ac79be37279dfd4872d14c795eb47ab5485b157"
  end

  resource "craft-platforms" do
    url "https://files.pythonhosted.org/packages/93/b9/b7bef735949e73756910d85c1d4178e5c6523b70e5dbe5477ab0c2fd8d81/craft_platforms-0.11.1.tar.gz"
    sha256 "5807e2b727c0cb9c7c85e5ecaf4181ed1b3f89e6232464736369dcb871ae9339"
  end

  resource "craft-providers" do
    url "https://files.pythonhosted.org/packages/84/be/6efaee42ee0f77de93bd9bdb3e3bbad8b67c8457a4ecef835f3277c5e368/craft_providers-3.7.0.tar.gz"
    sha256 "b61dbecbfa17fe77f4fda80e883b96c833fa1ddcc6d783a3d1688ae1e09ce17e"
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
    url "https://files.pythonhosted.org/packages/84/f5/ccf58de92d61e3ad921119668f54ed36ca1d0cf5dcc5c1657dfb164fd78b/httplib2-0.32.0.tar.gz"
    sha256 "48a0ef30a42db65d8f3399045e1d09ab0ba66e3b9efc360d07f80ea55d286025"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
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
    url "https://files.pythonhosted.org/packages/88/a9/2f81f86bb83c32c3ab585e58c32871c5ce99011293104f8a3c955909397d/lazr_uri-1.0.8.tar.gz"
    sha256 "0e45854eb22687958dfb807655ff7e095b1765be649e24ccc581934d0337d3b4"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/40/71/d89bb0e71b1415453980fd32315f2a037aad9f7f70f695c7cec7035feb13/license_expression-30.4.4.tar.gz"
    sha256 "73448f0aacd8d0808895bdc4b2c8e01a8d67646e4188f887375398c761f340fd"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/05/3b/aab6728cae887456f409b4d75e8a01856e4f04bd510de38052a47768b680/lxml-6.1.1.tar.gz"
    sha256 "ba96ae44888e0185281e937633a743ea90d5a196c6000f82565ebb0580012d40"
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
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "pylxd" do
    url "https://files.pythonhosted.org/packages/23/b2/ed81d9cebf8c81b0f76db47cc8cf844475cb11aa1963b8cd87e11fd2fce9/pylxd-2.4.1.tar.gz"
    sha256 "db539951d1e593e562315ec90031f6635020e2a7174f8328a63207e8db854c15"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
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
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
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
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "snap-helpers" do
    url "https://files.pythonhosted.org/packages/50/2a/221ab0a9c0200065bdd8a5d2b131997e3e19ce81832fdf8138a7f5247216/snap-helpers-0.4.2.tar.gz"
    sha256 "ef3b8621e331bb71afe27e54ef742a7dd2edd9e8026afac285beb42109c8b9a9"
  end

  resource "snap-http" do
    url "https://files.pythonhosted.org/packages/4a/d3/0a177f3d30273650a4d4a12d43af71c3cce198f9f309ac7b3f4d3f18d661/snap_http-1.12.0.tar.gz"
    sha256 "c04e498474162ff565729e0756a99a658e4f757cb9689a79fbee68716cb7d29d"
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
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "wadllib" do
    url "https://files.pythonhosted.org/packages/ab/f8/c7681d8d8dca6aa1f90e054bde451c25741fde702b21c347fe65fb813543/wadllib-2.1.0.tar.gz"
    sha256 "69c60a188c9c629a0e947dfafd89acdc8b7d8d404a6b5eb0ad258fef29362501"
  end

  resource "ws4py" do
    url "https://files.pythonhosted.org/packages/cb/55/dd8a5e1f975d1549494fe8692fc272602f17e475fe70de910cdd53aec902/ws4py-0.6.0.tar.gz"
    sha256 "9f87b19b773f0a0744a38f3afa36a803286dd3197f0bb35d9b75293ec7002d19"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
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
