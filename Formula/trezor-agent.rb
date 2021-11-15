class TrezorAgent < Formula
  include Language::Python::Virtualenv

  desc "Hardware SSH/GPG agent for Trezor, Keepkey & Ledger"
  homepage "https://github.com/romanz/trezor-agent"
  url "https://files.pythonhosted.org/packages/f1/a7/8989377dfce48abf9115055baf6d2cfba55102929a7c5f3e5b9c8e8b5c18/trezor_agent-0.11.0.tar.gz"
  sha256 "139d917d6495bf290bcc21da457f84ccd2e74c78b4d59a649e0cdde4288cd20c"
  license "LGPL-3.0"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_monterey: "aec7613e0e5550c77c53b7f361ceb2a174fded1bf4a9f22ded7dd9ad3617ad22"
    sha256 cellar: :any, arm64_big_sur:  "649504c1157a1d26ab9a62498558c69c68660a4c0d0aee91d9f31df05f050a89"
    sha256 cellar: :any, monterey:       "826c736a274a694260f0c5acde787b79ba82c9871a9d809a047fe3861ab317dd"
    sha256 cellar: :any, big_sur:        "6490433e0dca638943777905fd23a0cd4ea450e2b2f4c2bf9deca0fd48b85f7a"
    sha256 cellar: :any, catalina:       "480b6bad50684dc8e8786aeafd42720a0b335a39c0f9745f772cf3cb8b585df4"
  end

  depends_on "libusb"
  depends_on "pillow"
  depends_on "python@3.9"
  depends_on "six"

  # Gather dependencies for trezor-agent, ledger-agent & keepkey-agent

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "backports.shutil_which" do
    url "https://files.pythonhosted.org/packages/a0/22/51b896a4539f1bff6a7ab8514eb031b9f43f12bff23f75a4c3f4e9a666e5/backports.shutil_which-3.5.2.tar.gz"
    sha256 "fe39f567cbe4fad89e8ac4dbeb23f87ef80f7fe8e829669d0221ecdb0437c133"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/39/2b/c68eaf8294f01ea534f39b8b4ec1d7308b5195e08570c276b104bccd24ff/construct-2.10.67.tar.gz"
    sha256 "730235fedf4f2fee5cfadda1d14b83ef1bf23790fb1cc579073e10f70a050883"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/61/d7/8b2786f10b73e546aa9a85c2791393a6f475a16771b8028c7fb93d6ac8ce/docutils-0.18.tar.gz"
    sha256 "c1d5dab2b11d16397406a282e53953fe495a46d69ae329f55aa98a5c4e3c5fbb"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/bf/3d/3d909532ad541651390bf1321e097404cbd39d1d89c2046f42a460220fb3/ecdsa-0.17.0.tar.gz"
    sha256 "b9f500bb439e4153d0330610f5d26baaf18d17b8ced1bc54410d189385ea68aa"
  end

  resource "ECPy" do
    url "https://files.pythonhosted.org/packages/e0/48/3f8c1a252e3a46fd04e6fabc5e11c933b9c39cf84edd4e7c906e29c23750/ECPy-1.2.5.tar.gz"
    sha256 "9635cffb9b6ecf7fd7f72aea1665829ac74a1d272006d0057d45a621aae20228"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "hidapi" do
    url "https://files.pythonhosted.org/packages/dc/aa/38708a1d85d13dec22e756feb4e02f8b3adc5937bfe976f8f998717ff0a3/hidapi-0.11.0.post2.tar.gz"
    sha256 "da815e0d1d4b2ef1ebbcc85034572105dca29627eb61881337aa39010f2ef8cb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "keepkey" do
    url "https://files.pythonhosted.org/packages/30/38/558d9a2dd1fd74f50ff4587b4054496ffb69e21ab1138eb448f3e8e2f4a7/keepkey-6.3.1.tar.gz"
    sha256 "cef1e862e195ece3e42640a0f57d15a63086fd1dedc8b5ddfcbc9c2657f0bb1e"
  end

  resource "keepkey_agent" do
    url "https://files.pythonhosted.org/packages/65/72/4bf47a7bc8dc93d2ac21672a0db4bc58a78ec5cee3c4bcebd0b4092a9110/keepkey_agent-0.9.0.tar.gz"
    sha256 "47c85de0c2ffb53c5d7bd2f4d2230146a416e82511259fad05119c4ef74be70c"
  end

  resource "ledger_agent" do
    url "https://files.pythonhosted.org/packages/a3/c9/ac7546d6168662af356493231ca8818bdf8ffd05238a68fe5085fd9e6358/ledger_agent-0.9.0.tar.gz"
    sha256 "2265ba9c6a4594ff798fe480856ea36bfe6d8ae7ba2190b74f9666510530f20f"
  end

  resource "ledgerblue" do
    url "https://files.pythonhosted.org/packages/03/e7/d6181ccfcd7e2ccda67e3e5d1087d527036fe085316098ff367a07f35a66/ledgerblue-0.1.38.tar.gz"
    sha256 "df1fffc4f586eaa95b8cf910176d28997e65a3ecd43d9c0af34e46078b6b6ee3"
  end

  resource "libagent" do
    url "https://files.pythonhosted.org/packages/58/6c/be496e868b30c0103ceb7bef9653058c85b401e322dfcb86ba064f5bcad8/libagent-0.14.3.tar.gz"
    sha256 "c606343a7fcdbb7e896be41d095755185df2ecb50ef8ada98df757a4ef81aa55"
  end

  resource "libusb1" do
    url "https://files.pythonhosted.org/packages/a9/97/e8afa2af12b6de608ec86c8c4ad57f1248d98946d1b5e1aa0bff926755e9/libusb1-2.0.1.tar.gz"
    sha256 "d3ba82ecf7ab6a48d21dac6697e26504670cc3522b8e5941bd28fb56cf3f6c46"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mnemonic" do
    url "https://files.pythonhosted.org/packages/f8/8d/d4dc2b2bddfeb57cab4404a41749b577f578f71140ab754da9afa8f5c599/mnemonic-0.20.tar.gz"
    sha256 "7c6fb5639d779388027a77944680aee4870f0fcd09b1e42a5525ee2ce4c625f6"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/37/52/4e40f7513b44671817a92dc566f4a6e8eba65bfc94f79da23186e6c127ce/protobuf-3.19.1.tar.gz"
    sha256 "62a8e4baa9cb9e064eb62d1002eca820857ab2138440cb4b3ea4243830f94ca7"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/47/14/dd9ad29cd29ea4cc521286f2cb401ca7ac6fd5db0791c5e9bacaf2c9ac78/pycryptodomex-3.11.0.tar.gz"
    sha256 "0398366656bb55ebdb1d1d493a7175fc48ade449283086db254ac44c7d318d6d"
  end

  resource "PyMsgBox" do
    url "https://files.pythonhosted.org/packages/7d/ff/4c6f31a4f08979f12a663f2aeb6c8b765d3bd592e66eaaac445f547bb875/PyMsgBox-1.0.9.tar.gz"
    sha256 "2194227de8bff7a3d6da541848705a155dcbb2a06ee120d9f280a1d7f51263ff"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/d6/2d/f5e9a44e76777ca5c20765d92eb2d2cb89b6cfa5e921c808fdd57c90cae7/python-daemon-2.3.0.tar.gz"
    sha256 "bda993f1623b1197699716d68d983bb580043cf2b8a66a01274d9b8297b0aeaf"
  end

  resource "python-u2flib-host" do
    url "https://files.pythonhosted.org/packages/4d/3d/0997fe8196f5be24b7015708a0744a0ef928c4fb3c8bc820dc3328208ef2/python-u2flib-host-3.0.3.tar.gz"
    sha256 "ab678b9dc29466a779efcaa2f0150dce35059a7d17680fc26057fa599a53fc0a"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/31/a9/b61190916030ee9af83de342e101f192bbb436c59be20a4cb0cdb7256ece/semver-2.13.0.tar.gz"
    sha256 "fa0fe2722ee1c3f57eac478820c3a5ae2f624af8264cbdf9000c980ff7f75e3f"
  end

  resource "trezor" do
    url "https://files.pythonhosted.org/packages/90/4e/d822976f6c043ba5d3e242ddf3ce62967dcceb5936764080e4457388d59c/trezor-0.12.4.tar.gz"
    sha256 "3e180d9f9f8b69176b5ef36311b6161f5b793b538eb2dfd4babbb4d3fb1e374e"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/ed/12/c5079a15cf5c01d7f4252b473b00f7e68ee711be605b9f001528f0298b98/typing_extensions-3.10.0.2.tar.gz"
    sha256 "49f75d16ff11f1cd258e1b988ccff82a3ca5570217d7ad8c5f48205dd99a677e"
  end

  resource "Unidecode" do
    url "https://files.pythonhosted.org/packages/41/a6/93288318cfae2fa0ca978dfe6bb94b22b7e9a9e98b6149a4af00b1e76ee8/Unidecode-1.3.2.tar.gz"
    sha256 "669898c1528912bcf07f9819dc60df18d057f7528271e31f8ec28cc88ef27504"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/4e/8f/b5c45af5a1def38b07c09a616be932ad49c35ebdc5e3cbf93966d7ed9750/websocket-client-1.2.1.tar.gz"
    sha256 "8dfb715d8a992f5712fff8c843adae94e22b22a99b2c5e6b0ec4a1a981cc4e0d"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/4e/be/8139f127b4db2f79c8b117c80af56a3078cc4824b5b94250c7f81a70e03b/wheel-0.37.0.tar.gz"
    sha256 "e2ef7239991699e3355d54f8e968a21bb940a1dbf34a4d226741e64462516fad"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/trezor-agent identity@myhost 2>&1", 1)
    assert_match "Trezor not connected", output
  end
end
