class ReconNg < Formula
  include Language::Python::Virtualenv

  desc "Web Reconnaissance Framework"
  homepage "https://github.com/lanmaster53/recon-ng"
  url "https://github.com/lanmaster53/recon-ng/archive/v5.1.0.tar.gz"
  sha256 "ee5e51d84abdf9f01c8aec78c35bd0261253963fa5f3b19824336ab15f2b1889"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc2efc5e810a1f34638cfab2130eca793e96f18b56efdcdee15f02ba225e8c54" => :catalina
    sha256 "7b4c2cd237f8f8ce646a8f7fefd90db3a185d7c84518c822ed27ce675e01d29d" => :mojave
    sha256 "81451de88a5e4beb277e35d2a80bed0a879db99ffe69280acc57f0c4997d477e" => :high_sierra
  end

  depends_on "python"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/bf/9d214a5af07debc6acf7f3f257265618f1db242a3f8e49a9b516f24523a6/certifi-2019.11.28.tar.gz"
    sha256 "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "dicttoxml" do
    url "https://files.pythonhosted.org/packages/74/36/534db111db9e7610a41641a1f6669a964aacaf51858f466de264cc8dcdd9/dicttoxml-1.7.4.tar.gz"
    sha256 "ea44cc4ec6c0f85098c57a431a1ee891b3549347b07b7414c8a24611ecf37e45"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ec/c5/14bcd63cb6d06092a004793399ec395405edf97c2301dfdc146dfbd5beed/dnspython-1.16.0.zip"
    sha256 "36c5e8e38d4369a08b6780b7f27d790a292b2b08eea01607865bf0936c558e01"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/2e/80/3726a729de758513fd3dbc64e93098eb009c49305a97c6751de55b20b694/Flask-1.1.1.tar.gz"
    sha256 "13f9f196f330c7c2c5d7a5cf91af894110ca0215ac051b5844701f2bfd934d52"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e4/19/8dfeef50623892577dc05245093e090bb2bab4c8aed5cad5b03208959563/lxml-4.4.2.tar.gz"
    sha256 "eff69ddbf3ad86375c344339371168640951c302450c5d3e9936e98d6459db06"
  end

  resource "mechanize" do
    url "https://files.pythonhosted.org/packages/06/4d/1cb6d4e395a6d487d294c78e0d613a0b18b0c4351cc92059f39c699ac65f/mechanize-0.4.4.tar.gz"
    sha256 "9fff89e973bdf1aee75a351bd4dde53ca51a7e76944ddeae3ea3b6ad6c46045c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/8d/c9/e5be955a117a1ac548cdd31e37e8fd7b02ce987f9655f5c7563c656d5dcb/PyYAML-5.2.tar.gz"
    sha256 "c0ee8eca2c582d29c3c2ec6e2c4f703d1b7f1fb10bc72317355a746057e7346c"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "unicodecsv" do
    url "https://files.pythonhosted.org/packages/6f/a4/691ab63b17505a26096608cc309960b5a6bdf39e4ba1a793d5f9b1a53270/unicodecsv-0.14.1.tar.gz"
    sha256 "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ad/fc/54d62fa4fc6e675678f9519e677dfc29b8964278d75333cf142892caf015/urllib3-1.25.7.tar.gz"
    sha256 "f3c5fd51747d450d4dcf6f923c81f78f811aab8205fda64b0aba34a4e48b0745"
  end

  resource "XlsxWriter" do
    url "https://files.pythonhosted.org/packages/80/29/071fc0366975032d4cd7190ec2b5491e2d1b6b5efb9b58b673be188d4350/XlsxWriter-1.2.6.tar.gz"
    sha256 "027fa3d22ccfb5da5d77c29ed740aece286a9a6cc101b564f2f7ca11eb1d490b"
  end

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    libexec.install Dir["*"]
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources

    # Replace shebang with virtualenv python
    inreplace libexec/"recon-ng", "#!/usr/bin/env python3", "#!#{libexec}/bin/python"

    bin.install_symlink libexec/"recon-ng"
  end

  test do
    (testpath/"resource").write <<~EOS
      options list
      exit
    EOS
    system "#{bin}/recon-ng", "-r", testpath/"resource"
  end
end
