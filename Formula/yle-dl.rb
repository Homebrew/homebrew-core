class YleDl < Formula
  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://github.com/aajanki/yle-dl/archive/2.29.tar.gz"
  sha256 "62ebf2641f2f5ed602d5356c62075eaaf308e117ae7a9bd1ec26c07bcf24c94e"
  head "https://github.com/aajanki/yle-dl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce316baa93267def3a8a67969c372c816565bed5d541ff02687ce69b8b8c482c" => :high_sierra
    sha256 "07f5156cd6f3489f3b84571f66831d9fd60639e6cdccdb7e9b80e8fbf6eb55bb" => :sierra
    sha256 "2678b75a6ac5bfc895837baadb3e3b9763811362fe6d0bc32bec953a0d37a14d" => :el_capitan
  end

  depends_on "rtmpdump"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "homebrew/php/php70-mcrypt" => :optional
  depends_on "homebrew/php/php56-mcrypt" => :optional
  depends_on "homebrew/php/php55-mcrypt" => :optional
  depends_on "homebrew/php/php54-mcrypt" => :optional
  depends_on "homebrew/php/php53-mcrypt" => :optional

  resource "AdobeHDS.php" do
    # NOTE: yle-dl always installs the HEAD version of AdobeHDS.php. We use a specific commit.
    # Check if there are bugfixes at https://github.com/K-S-V/Scripts/commits/master/AdobeHDS.php
    url "https://raw.githubusercontent.com/K-S-V/Scripts/3a9b748f957a921c5f846b3ebc7c99bb8255d2e0/AdobeHDS.php"
    sha256 "45adf9b03dc991fcf6a44bb4cf62dd3777bf69647f1a98290e160a2bf89ebc2d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/23/3f/8be01c50ed24a4bd6b8da799839066ce0288f66f5e11f0367323467f0cbc/certifi-2017.11.5.tar.gz"
    sha256 "5ec74291ca1136b40f0379e1128ff80e866597e4e2c1e755739a913bbc3613c0"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/74/ba/4ba4e89e21b5a2e267d80736ea674609a0a33cc4435a6d748ef04f1f9374/defusedxml-0.5.0.tar.gz"
    sha256 "24d7f2f94f7f3cb6061acb215685e5125fbcdc40a857eff9de22518820b0a4f4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e1/4c/d83979fbc66a2154850f472e69405572d89d2e6a6daee30d18e83e39ef3a/lxml-4.1.1.tar.gz"
    sha256 "940caef1ec7c78e0c34b0f6b94fe42d0f2022915ffc78643d28538a5cfd0f40e"
  end

  resource "PyAMF" do
    url "https://files.pythonhosted.org/packages/a0/06/43976c0e3951b9bf7ba0d7d614a8e3e024eb5a1c6acecc9073b81c94fb52/PyAMF-0.8.0.tar.gz"
    sha256 "0455d68983e3ee49f82721132074877428d58acec52f19697a88c03b5fba74e4"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    (resources - [resource("AdobeHDS.php")]).each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    resource("AdobeHDS.php").stage(pkgshare)

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<~EOS
    yle-dl requires the mcrypt PHP module which you can either install manually or install
    mcrypt from the PHP homebrew tap. You can also install yle-dl with one of optional dependencies
    which to automatically tap the php tap and download mcrypt module for you.

      brew info yle-dl

    for further info.
    EOS
  end

  test do
    assert_equal "Traileri: 3 minuuttia-2012-05-30T10:51\n",
                 shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
  end
end
