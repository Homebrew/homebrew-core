class Streamlink < Formula
  desc "CLI for extracting streams from various websites to a video player"
  homepage "https://streamlink.github.io/"
  url "https://github.com/streamlink/streamlink/releases/download/0.9.0/streamlink-0.9.0.tar.gz"
  sha256 "8c01c23a3e02d75a09232ac471a7c277a699455293a99e8a2ec0846a1b4a6819"

  bottle do
    cellar :any_skip_relocation
    sha256 "df3c2fd970330311673a293f72f736b45f4aa45716e652c12844a19e5dbb8d97" => :high_sierra
    sha256 "e89c0e7d4496016f268ebb312d8b3db39557ccadafbfaeae751453074c389a93" => :sierra
    sha256 "e32ba44879d89cfeed23ac45abef84cf20651c4854814c7563f221a1f47f0989" => :el_capitan
  end

  # Use :python on Yosemite and prior to avoid needing urllib3[secure]
  # See https://github.com/streamlink/streamlink/commit/0f35b9b2
  depends_on "python" if MacOS.version <= :yosemite

  resource "backports.shutil_get_terminal_size" do
    url "https://files.pythonhosted.org/packages/ec/9c/368086faa9c016efce5da3e0e13ba392c9db79e3ab740b763fe28620b18b/backports.shutil_get_terminal_size-1.0.0.tar.gz"
    sha256 "713e7a8228ae80341c70586d1cc0a8caa5207346927e23d09dcbcaf18eadec80"
  end

  resource "backports.shutil_which" do
    url "https://files.pythonhosted.org/packages/dd/ea/715dc80584207a0ff4a693a73b03c65f087d8ad30842832b9866fe18cb2f/backports.shutil_which-3.5.1.tar.gz"
    sha256 "dd439a7b02433e47968c25a45a76704201c4ef2167deb49830281c379b1a4a9b"
  end

  resource "backports.ssl_match_hostname" do
    url "https://files.pythonhosted.org/packages/76/21/2dc61178a2038a5cb35d14b61467c6ac632791ed05131dda72c20e7b9e23/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/23/3f/8be01c50ed24a4bd6b8da799839066ce0288f66f5e11f0367323467f0cbc/certifi-2017.11.5.tar.gz"
    sha256 "5ec74291ca1136b40f0379e1128ff80e866597e4e2c1e755739a913bbc3613c0"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/cc/26/b61e3a4eb50653e8a7339d84eeaa46d1e93b92951978873c220ae64d0733/futures-3.1.1.tar.gz"
    sha256 "51ecb45f0add83c806c68e4b06106f90db260585b25ef2abfcda0bd95c0132fd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "iso-639" do
    url "https://files.pythonhosted.org/packages/5a/8d/27969852f4e664525c3d070e44b2b719bc195f4d18c311c52e57bb93614e/iso-639-0.4.5.tar.gz"
    sha256 "dc9cd4b880b898d774c47fe9775167404af8a85dd889d58f9008035109acce49"
  end

  resource "iso3166" do
    url "https://files.pythonhosted.org/packages/46/06/64145b8d6be8474db1f09f6b01a083921c11a4c979d029677c7e943d2433/iso3166-0.8.tar.gz"
    sha256 "fbeb17bed90d15b1f6d6794aa2ea458e5e273a1d29b6f4939423c97640e14933"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/2b/9b/aaa940ab8affd66eed043d69332dc607cddd68f9e399d93dcdfc8149fb21/pycryptodome-3.4.7.tar.gz"
    sha256 "18d8dfe31bf0cb53d58694903e526be68f3cf48e6e3c6dfbbc1e7042b1693af7"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/7d/38/edca891ce16827a1de45cc347e4b6c22311eba25838b9825a5e6c48cf560/PySocks-1.6.7.tar.gz"
    sha256 "d00329f27efa157db7efe3ca26fcd69033cd61f83822461ee3f8a353b48e33cf"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "singledispatch" do
    url "https://files.pythonhosted.org/packages/d9/e9/513ad8dc17210db12cb14f2d4d190d618fb87dd38814203ea71c87ba5b68/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/06/19/f00725a8aee30163a7f257092e356388443034877c101757c1466e591bf8/websocket_client-0.44.0.tar.gz"
    sha256 "15f585566e2ea7459136a632b9785aa081093064391878a448c382415e948d72"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/streamlink", "https://www.youtube.com/watch?v=he2a4xK8ctk", "144p", "-o", "video.mp4"
    assert_match "video.mp4: ISO Media, MPEG v4 system, 3GPP", shell_output("file video.mp4")
  end
end
