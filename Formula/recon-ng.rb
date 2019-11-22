class ReconNg < Formula
  include Language::Python::Virtualenv

  desc "Web Reconnaissance Framework"
  homepage "https://github.com/lanmaster53/recon-ng"
  url "https://github.com/lanmaster53/recon-ng/archive/v5.0.1.tar.gz"
  sha256 "a090caa5d2a380cf34a54e3759cdad2da5dc17a0eaaf88260721f6a60a4064ab"

  bottle do
    cellar :any_skip_relocation
    sha256 "f371f38a115d15a8d9a0e5bb27e8d96594bf19683f2cfd5daf9798baa797c881" => :catalina
    sha256 "9b95337526fddba4a46d9ed0ffb6fdef87167f273f0bd802651e158c07367007" => :mojave
    sha256 "7c547187508a2311a94f5e057f5c6e0675a916d6f06c935ab202870ca9989513" => :high_sierra
  end

  depends_on "python"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/62/85/7585750fd65599e88df0fed59c74f5075d4ea2fe611deceb95dd1c2fb25b/certifi-2019.9.11.tar.gz"
    sha256 "e4f3620cfea4f83eedc95b24abd9cd56f3c4b146dd0177e83a21b4eb49e21e50"
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
    url "https://files.pythonhosted.org/packages/c4/43/3f1e7d742e2a7925be180b6af5e0f67d38de2f37560365ac1a0b9a04c015/lxml-4.4.1.tar.gz"
    sha256 "c81cb40bff373ab7a7446d6bbca0190bccc5be3448b47b51d729e37799bb5692"
  end

  resource "mechanize" do
    url "https://files.pythonhosted.org/packages/64/f1/1aa4c96dea14e17a955019b0fc4ac1b8dfbc50e3c90970c1fb8882e74a7b/mechanize-0.4.3.tar.gz"
    sha256 "d7d7068be5e1b3069575c98c870aaa96dd26603fe8c8697b470e2f65259fddbf"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/e3/e8/b3212641ee2718d556df0f23f78de8303f068fe29cdaa7a91018849582fe/PyYAML-5.1.2.tar.gz"
    sha256 "01adf0b6c6f61bd11af6e10ca52b7d4057dd0be0343eb9283c878cf3af56aee4"
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
    url "https://files.pythonhosted.org/packages/ff/44/29655168da441dff66de03952880c6e2d17b252836ff1aa4421fba556424/urllib3-1.25.6.tar.gz"
    sha256 "9a107b99a5393caf59c7aa3c1249c16e6879447533d0887f4336dde834c7be86"
  end

  resource "XlsxWriter" do
    url "https://files.pythonhosted.org/packages/91/c2/9b33661b53065464febd85805037a52c4f066d2cadc540052ae83dfaf792/XlsxWriter-1.2.1.tar.gz"
    sha256 "7f41b1dbd6b38dd1ce243156cac54d1dae50a41f4a45871596ca67b0abcfb3e8"
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
