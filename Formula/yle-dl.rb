class YleDl < Formula
  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://github.com/aajanki/yle-dl/archive/2.22.tar.gz"
  sha256 "076423a45f0b3576731568d287ce84e3f444982394b8b56759dd9ae58d77ca95"

  head "https://github.com/aajanki/yle-dl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb3a277e4000d890875e0f88540af463e45a40ee85dde40b4ca6413670a5f5fa" => :sierra
    sha256 "2c0d6fa6e513a9e993e30183c9a6e1baa16fcf0a2a26c937d55f1adfb79db622" => :el_capitan
    sha256 "8cfbc33c03f710dc78934a2ad9bc639f7a64b5c891ca7a3b09308169a216f3a5" => :yosemite
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
    url "https://files.pythonhosted.org/packages/20/d0/3f7a84b0c5b89e94abbd073a5f00c7176089f526edb056686751d5064cbd/certifi-2017.7.27.1.tar.gz"
    sha256 "40523d2efb60523e113b44602298f0960e900388cf3bb6043f645cf57ea9e3f5"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "progress" do
    url "https://files.pythonhosted.org/packages/37/15/66bb190760a7129b65bf07eb23cdade607d91f894496121c16a9ada5d9f9/progress-1.3.tar.gz"
    sha256 "c88d89ee3bd06716a0b8b5504d9c3bcb3c1c0ab98f96dc7f1dc5f56812a4f60a"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c3/38/d95ddb6cc8558930600be088e174a2152261a1e0708a18bf91b5b8c90b22/requests-2.18.3.tar.gz"
    sha256 "fb68a7baef4965c12d9cd67c0f5a46e6e28be3d8c7b6910c758fbcc99880b518"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  def install
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

  def caveats; <<-EOS.undent
    yle-dl requires the mcrypt PHP module which you can either install manually or install
    mcrypt from the PHP homebrew tap. You can also install yle-dl with one of optional dependencies
    which to automatically tap the php tap and download mcrypt module for you.

      brew info yle-dl

    for further info.
    EOS
  end

  test do
    assert_equal "Traileri: 3 minuuttia-2012-05-30T10:51:00+03:00\n",
                 shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
  end
end
