class YleDl < Formula
  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/63/7c/d1ef5a4b7fefe2190a1a7cebdb2332ef382f1f5e491c55721bf7819ef20b/yle-dl-20211203.tar.gz"
  sha256 "1360f0357474a52ceba937aed78a0fed0788073b1db9b77bc70051733f09a0c7"
  license "GPL-3.0-or-later"
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c873de356c76031225898cfc91952dc308167590c5e5cb5b713f26f932063ddb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0227df9cc74fa2378e5f96d3cf021a1b242840621d21d1891e3448d470f76d12"
    sha256 cellar: :any_skip_relocation, monterey:       "3ffb0952253e74d74b236b1ba0c8b261ebac5d3bd38599687911e8411d05eab9"
    sha256 cellar: :any_skip_relocation, big_sur:        "74de7ba58e7fb1acac55cc45315c7ec39b60ec060349374c81baff6c0282af7b"
    sha256 cellar: :any_skip_relocation, catalina:       "e2c69ab631d4248163131a3f52f5e4807768066d17f26df0245cea49c5cbc0be"
    sha256 cellar: :any_skip_relocation, mojave:         "b6dac24972fca38490b5e18dfa37d926b597b05bc68ecb0a8c3bf82e50028014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c42bf1e861338903291495ff808cef49fd4c4ebb00f082adfec6011a692c82fb"
  end

  depends_on "ffmpeg"
  depends_on "python@3.9"
  depends_on "rtmpdump"

  uses_from_macos "libxslt"

  # `Cannot import name "Feature" from "setuptools" in version 46.0.0`, and lock setuptools to v45.0.0
  # https://github.com/pypa/setuptools/issues/2017#issuecomment-605354361
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/fd/76/3c7f726ed5c582019937f178d7478ce62716b7e8263344f1684cbe11ab3e/setuptools-45.0.0.zip"
    sha256 "c46d9c8f2289535457d36c676b541ca78f7dcb736b97d02f50d17f7f15b583cc"
  end

  resource "AdobeHDS.php" do
    # NOTE: yle-dl always installs the HEAD version of AdobeHDS.php. We use a specific commit.
    # Check if there are bugfixes at https://github.com/K-S-V/Scripts/commits/master/AdobeHDS.php
    url "https://raw.githubusercontent.com/K-S-V/Scripts/7fea932cb012cba8c203d5b46b891167b0f609a6/AdobeHDS.php"
    sha256 "b79e8a4c8544953c39b79a622049c4deced57354adb9697e8c73420c12547229"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/68/e4/e014e7360fc6d1ccc507fe0b563b4646d00e0d4f9beec4975026dd15850b/charset-normalizer-2.0.9.tar.gz"
    sha256 "b0b883e8e874edfdece9c28f314e3dd5badf067342e42fb162203335ae61aa2c"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/fe/4c/a4dbb4e389f75e69dbfb623462dfe0d0e652107a95481d40084830d29b37/lxml-4.6.4.tar.gz"
    sha256 "daf9bd1fee31f1c7a5928b3e1059e09a8d683ea58fb3ffc773b6c88cb8d1399c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    (resources - [resource("AdobeHDS.php")]).each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    resource("AdobeHDS.php").stage(pkgshare)

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    output = shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
    assert_match "Traileri:", output
    assert_match "2012-05-30T10:51", output
  end
end
