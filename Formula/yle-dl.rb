class YleDl < Formula
  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://files.pythonhosted.org/packages/e2/bf/9111331d2e13a10614b3f97a5bcce96c5eea03d3791957ccf2fdcba95872/yle-dl-20220610.tar.gz"
  sha256 "4913f028db6304345aea2e784de8d343e007bd43760cdc0f518a61f324f808cb"
  license "GPL-3.0-or-later"
  head "https://github.com/aajanki/yle-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "171a8e4c3eeb7851abca9bf77b41d90abf32525b184d048a9410553f4709625d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "150bd0a2bde4802b3074ff05be0e978d7834bf4c70e5c722317357f9a6c35efd"
    sha256 cellar: :any_skip_relocation, monterey:       "b1a0c42271a7387a9915bf0ccc192e279b108fe5434f6705a53545fea7b4df7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf7188b9f0d488afcc2314511a0e2238d43903241fc26578b39785cb1f7e6275"
    sha256 cellar: :any_skip_relocation, catalina:       "be1b4210be30f2f8e6c981f594d39224ddf2eead1c4b96ce744583fd3fbf73da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "759d162213ae4ca78f45edf2762e27fac9e03a9dbc8d5a3189711dfb22e9a6a7"
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
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/07/10/75277f313d13a2b74fc56e29239d5c840c2bf09f17bf25c02b35558812c6/certifi-2022.5.18.1.tar.gz"
    sha256 "9c5705e395cd70084351dd8ad5c41e65655e08ce46f2ec9cf6c2c08390f71eb7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
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
    url "https://files.pythonhosted.org/packages/aa/23/bda4e9881090f0f5e33e2efe89aacfa0668eb6e1ab2de28591e2912d78d4/lxml-4.9.0.tar.gz"
    sha256 "520461c36727268a989790aef08884347cd41f2d8ae855489ccf40b50321d8d7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e9/23/384d9953bb968731212dc37af87cb75a885dc48e0615bd6a303577c4dc4b/requests-2.28.0.tar.gz"
    sha256 "d568723a7ebd25875d8d1eaf5dfa068cd2fc8194b2e483d7b1f7c81918dbec6b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  def install
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
