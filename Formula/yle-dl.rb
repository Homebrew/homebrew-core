class YleDl < Formula
  desc "Download Yle videos from the command-line"
  homepage "https://aajanki.github.io/yle-dl/index-en.html"
  url "https://github.com/aajanki/yle-dl/archive/20200628.tar.gz"
  sha256 "4b8ef130b80b0bcfe953d56aef640f09227e6e64486104c53bc8f5af79615e9f"
  license "GPL-3.0"
  head "https://github.com/aajanki/yle-dl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "513097c2d1d174c14eec82353155dca6efcded472ee4fce426c9c01f28821010" => :catalina
    sha256 "63de53da03bec566091483b0cb3b362fa41c1111cfb25c0cc55836e40e016dd4" => :mojave
    sha256 "7ba726d1b94eb47170aa85b1f173c68a2e52514127692467fbd47068085b32d7" => :high_sierra
  end

  depends_on "python@3.8"
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
    url "https://files.pythonhosted.org/packages/98/c3/2c227e66b5e896e15ccdae2e00bbc69aa46e9a8ce8869cc5fa96310bf612/attrs-19.3.0.tar.gz"
    sha256 "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/a4/5f/f8aa58ca0cf01cbcee728abc9d88bfeb74e95e6cb4334cfd5bed5673ea77/defusedxml-0.6.0.tar.gz"
    sha256 "f684034d135af4c6cbb949b8a4d2ed61634515257a67299e5f940fbaa34377f5"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/03/a8/73d795778143be51d8b86750b371b3efcd7139987f71618ad9f4b8b65543/lxml-4.5.1.tar.gz"
    sha256 "27ee0faf8077c7c1a589573b1450743011117f1aa1a91d5ae776bbc5ca6070f2"
  end

  resource "Mini-AMF" do
    url "https://files.pythonhosted.org/packages/c9/a1/153af98d9ca4ae24fb67ab5cb8e4de8ad44fd991739f32d12b9321d6955d/Mini-AMF-0.9.1.tar.gz"
    sha256 "0c7839dc843b738cdcf5548e85558e7ebd89a9f6fd029751b0bb4d8b0ca4275b"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/7f/3c/80cfaec41c3a9d0f524fe29bca9ab22d02ac84b5bfd6e22ade97d405bdba/pycryptodomex-3.9.7.tar.gz"
    sha256 "50163324834edd0c9ce3e4512ded3e221c969086e10fdd5d3fdcaadac5e24a78"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz"
    sha256 "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/bb/79/3045743bb26ca2e44a1d317c37395462bfed82dbbd38e69a3280b63696ce/ConfigArgParse-1.2.3.tar.gz"
    sha256 "edd17be986d5c1ba2e307150b8e5f5107aba125f3574dddd02c85d5cdcfd37dc"
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
    assert_equal "Traileri: 3 minuuttia-2012-05-30T10:51\n",
                 shell_output("#{bin}/yle-dl --showtitle https://areena.yle.fi/1-1570236")
  end
end
