class Rockcraft < Formula
  include Language::Python::Virtualenv

  desc "Tool to create OCI images using the language from Snapcraft and Charmcraft"
  homepage "https://documentation.ubuntu.com/rockcraft/"
  # git checkout needed for setuptools-scm
  url "https://github.com/canonical/rockcraft.git",
      tag:      "1.20.0",
      revision: "289c48bc6bbf5c9132897d22785e7d5a2b2666b1"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/canonical/rockcraft.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "7033d6ef407a53ab6601ab4439ca23fca420031678e9645f8834c34e835ab7e4"
    sha256 cellar: :any, arm64_tahoe:       "30fe4669fa21f8de219583cf491af149a453a907416785506956d1ee59b1ea58"
    sha256 cellar: :any, arm64_sequoia:     "54cb565f0f49838008d6e8a32d6198fd99e97b8f7b6ffdd7cb186a17ec29288c"
    sha256 cellar: :any, arm64_linux:       "63a7dfe88396a6e174c785a81a3542b41e4f2988e9fa34fba157227c16cc9849"
    sha256 cellar: :any, x86_64_linux:      "0d1f26b5f504a2487af254dc0a4cceacc40182316653be058a7e2f3e95726d43"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography"
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "lxc"
  depends_on "pydantic" => :no_linkage
  depends_on "pygit2" => :no_linkage
  depends_on "python@3.15"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  # TODO: Remove this pin when a release includes the upstream vcs compatibility fix.
  # https://github.com/canonical/rockcraft/pull/1373
  pypi_packages exclude_packages: %w[certifi cryptography pydantic pygit2],
                extra_packages:   %w[craft-application==7.2.1 jeepney secretstorage]

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/c4/cf/85379f13b76f3a69bca86b60237978af17d6aa0bc5998978c3b8cf05abb2/boolean_py-5.0.tar.gz"
    sha256 "60cbc4bad079753721d32649545505362c754e121570ada4658b852a3a318d95"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "craft-application" do
    url "https://files.pythonhosted.org/packages/bf/30/9f520439e4f4a1c9ad538180b9c7057e4945c4e95994f2d2d93759202401/craft_application-7.2.1.tar.gz"
    sha256 "86f1f35be4b447bada10305d91a252b178d20910f3d5a7d5bb8ac6d3d9810d49"
  end

  resource "craft-archives" do
    url "https://files.pythonhosted.org/packages/0c/b9/e83ca9d07203ccbd7c083c4048a96e4c8a9b7e1341aad4ebe563071deaab/craft_archives-2.2.2.tar.gz"
    sha256 "463957aca9ea415b6392bab579746235f14640c6681426848d572ceedc53de21"
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
    url "https://files.pythonhosted.org/packages/a0/f2/507e3b1bd017f51bea6c70205744239b62eac20c552fa0ee1f1c30019752/craft_platforms-0.12.0.tar.gz"
    sha256 "497b6421fc5f464ee1f31da60ae1211bd3101722770afae72e0b330e54883e9d"
  end

  resource "craft-providers" do
    url "https://files.pythonhosted.org/packages/86/f5/81525f63af39d73be1fae45fc169eb036781d745a0220f95d9b7f6165549/craft_providers-3.7.1.tar.gz"
    sha256 "473e6228720dda9f042eae8b9584a1f1c41d6fd987c0fd9db0d69609d3c5f283"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "distro-support" do
    url "https://files.pythonhosted.org/packages/71/c0/4f42e876572b5b0f6f4f47e4f0660300b181b6d4c12bd333227fbb1e0b1a/distro_support-2026.8.10.tar.gz"
    sha256 "c7c8cc461393fb670be162da172ec3824e06a571860b5b2a682cdb2f8b789057"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/84/f5/ccf58de92d61e3ad921119668f54ed36ca1d0cf5dcc5c1657dfb164fd78b/httplib2-0.32.0.tar.gz"
    sha256 "48a0ef30a42db65d8f3399045e1d09ab0ba66e3b9efc360d07f80ea55d286025"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
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
    url "https://files.pythonhosted.org/packages/17/05/79115eea3f46a2048552b766d2e031740b53baff5a084d6a3f6318642ffe/launchpadlib-2.2.0.tar.gz"
    sha256 "d4f7bb6b95739d4667dd6093d410220317b2415b6c2ef5b143379ebc5f5363a9"
  end

  resource "lazr-restfulclient" do
    url "https://files.pythonhosted.org/packages/8c/9e/1e8005ee1c8450b428d48a242d0180f22e3dff5a18091c69a72699257158/lazr_restfulclient-4.0.0.tar.gz"
    sha256 "79577938dabce496675454105c37c5aa06deed7928818a98411adfb22f9e294b"
  end

  resource "lazr-uri" do
    url "https://files.pythonhosted.org/packages/4e/f5/d9abb50767cb9153917c567fb0c977ac6395c575d0c84fa7c4baa9d3a41a/lazr_uri-4.0.0.tar.gz"
    sha256 "d4a4e44b7c87269ab6c01dfd4c460b8f0492e2377c4215157c285929888efe5c"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/40/71/d89bb0e71b1415453980fd32315f2a037aad9f7f70f695c7cec7035feb13/license_expression-30.4.4.tar.gz"
    sha256 "73448f0aacd8d0808895bdc4b2c8e01a8d67646e4188f887375398c761f340fd"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/7a/d8/a1bcc8ba112a627f8ffbdc212a78ce18d3ac07e91a5ca65d27918eee25a1/oauthlib-4.0.0.tar.gz"
    sha256 "efb274799819440f95b4ab3b818869f1ce9ae26c5beacba0201d1a1b76b54f86"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/36/86/b585f53236dec60aba864e050778b25045f857e17f6e5ea0ae95fe80edd2/overrides-7.7.0.tar.gz"
    sha256 "55158fa3d93b98cc75299b1e67078ad9003ca27945c76162c1c0766d6f91820a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/80/a8/66d45abadff219e36e2a824181b8f6a67e7ed4572934d6252c71c29d5731/platformdirs-4.13.0.tar.gz"
    sha256 "1aa0b0d3f224c1f07c295121e312a5a24a180d6ae5a8425ea1784b3e3863e9c0"
  end

  resource "pylxd" do
    url "https://files.pythonhosted.org/packages/5c/47/91467f5d3cb9ec2f8e353aa9bb8c93e60949188dd845d02419b1788e9f63/pylxd-2.4.2.tar.gz"
    sha256 "759881fd94b6dda56ecde44ca1b7c0a7b478b4282ed950cff4f99e28cb207e3a"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-debian" do
    url "https://files.pythonhosted.org/packages/75/36/f90e7d006dd9311a6185f1c34b403dd6d76ff583e7962c56e9374c462a48/python_debian-1.1.1.tar.gz"
    sha256 "fe4fc3dc798dbf1f0ef5865e2b1b4f7cc0352b6a511b25ab7594906c64a73629"
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
    url "https://files.pythonhosted.org/packages/92/f5/e1dfe8e1d91c54ce212fd93916eb01fd1c590f413be0a0978c39a97aa1bb/semver-3.1.0.tar.gz"
    sha256 "14bc073439513d7773662a338f4db9829cf16c12b74b9568e2d2689975fbd7fc"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
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
    url "https://files.pythonhosted.org/packages/94/6b/18772132cd28914a99847913daef9c0f44ecea8f999baf51c9c7bfc7dae0/snap_http-1.12.1.tar.gz"
    sha256 "75e3ea0bd14bbf6498af24935160525f82035fbd0b001a86ccc541de230f5a9c"
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
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
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
