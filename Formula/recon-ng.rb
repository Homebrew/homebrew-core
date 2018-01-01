class ReconNg < Formula
  include Language::Python::Virtualenv

  desc "Web Reconnaissance Framework"
  homepage "https://bitbucket.org/LaNMaSteR53/recon-ng"
  url "https://bitbucket.org/LaNMaSteR53/recon-ng/get/v4.9.2.tar.gz"
  sha256 "1c10f155067c74f37734fb4c9e3e6fb651b3c075ca06aa7d9cc5b069dcaa3c1b"

  bottle do
    cellar :any_skip_relocation
    sha256 "66bb7b2a43e1546a53c7504ec2bd854abe8466e79a2f4fc092b826c13dc7e1f0" => :high_sierra
    sha256 "e4764cefc113d0ba91a0f07430bcfa58e5cdcf16a6c44ecd61f402d25d93d289" => :sierra
    sha256 "3904633fd2cc25d089c56a887bc1249461a90b3c74556c6287d1d0a610bb743b" => :el_capitan
    sha256 "86792cac092b8eb68a2585de3ed515027dde139b1565f0336824983789279ebd" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  ### setup_requires dependencies
  resource "dicttoxml" do
    url "https://files.pythonhosted.org/packages/74/36/534db111db9e7610a41641a1f6669a964aacaf51858f466de264cc8dcdd9/dicttoxml-1.7.4.tar.gz"
    sha256 "ea44cc4ec6c0f85098c57a431a1ee891b3549347b07b7414c8a24611ecf37e45"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/e4/96/a598fa35f8a625bc39fed50cdbe3fd8a52ef215ef8475c17cabade6656cb/dnspython-1.15.0.zip"
    sha256 "40f563e1f7a7b80dc5a4e76ad75c23da53d62f1e15e6e517293b04e1f84ead7c"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/eb/12/1c7bd06fcbd08ba544f25bf2c6612e305a70ea51ca0eda8007344ec3f123/Flask-0.12.2.tar.gz"
    sha256 "49f44461237b69ecd901cc7ce66feea0319b9158743dd27a2899962ab214dac1"
  end

  resource "jsonrpclib" do
    url "https://files.pythonhosted.org/packages/4f/84/d07e0a8e0ff14388e864a3e5fa1e0c03766c754d480d84f875604dc8c379/jsonrpclib-0.1.3.tar.gz"
    sha256 "a594e702c35408ae5540086ab5bdea284fb27d09520898c381c5bbdbfceffbba"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/20/b3/9f245de14b7696e2d2a386c0b09032a2ff6625270761d6543827e667d8de/lxml-3.8.0.tar.gz"
    sha256 "736f72be15caad8116891eb6aa4a078b590d231fdc63818c40c21624ac71db96"
  end

  resource "mechanize" do
    url "https://files.pythonhosted.org/packages/2e/cd/a7a1d00de588b1bdce5da6f914533c67b8d9fb9eb882a1fbe7f3fc0af433/mechanize-0.3.5.tar.gz"
    sha256 "d4f999b5a3028c900cb0e6ad3c996c73e3c69a664e6575493258104fa84d7166"
  end

  resource "olefile" do
    url "https://files.pythonhosted.org/packages/35/17/c15d41d5a8f8b98cc3df25eb00c5cee76193114c78e5674df6ef4ac92647/olefile-0.44.zip"
    sha256 "61f2ca0cd0aa77279eb943c07f607438edf374096b66332fae1ee64a6f0f73ad"
  end

  resource "PyPDF2" do
    url "https://files.pythonhosted.org/packages/b4/01/68fcc0d43daf4c6bdbc6b33cc3f77bda531c86b174cac56ef0ffdb96faab/PyPDF2-1.26.0.tar.gz"
    sha256 "e28f902f2f0a1603ea95ebe21dff311ef09be3d0f0ef29a3e44a932729564385"
  end

  resource "slowaes" do
    url "https://files.pythonhosted.org/packages/79/a4/c7dcbe89ec22a6985790bc0effb12bb8caef494fbac3c2bab86ae51a53ef/slowaes-0.1a1.tar.gz"
    sha256 "83658ae54cc116b96f7fdb12fdd0efac3a4e8c7c7064e3fac3f4a881aa54bf09"
  end

  resource "unicodecsv" do
    url "https://files.pythonhosted.org/packages/6f/a4/691ab63b17505a26096608cc309960b5a6bdf39e4ba1a793d5f9b1a53270/unicodecsv-0.14.1.tar.gz"
    sha256 "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc"
  end

  resource "XlsxWriter" do
    url "https://files.pythonhosted.org/packages/1c/1a/350a5fbee0ab3f54006004fe1b86d1f7df3556203417125435b7c6e57bf2/XlsxWriter-0.9.8.tar.gz"
    sha256 "1bba62325b7efc97b0bf9d8864cc7e31506263994d93404b94b0997fb47e1570"
  end

  def install
    libexec.install Dir["*"]
    venv = virtualenv_create(libexec)
    venv.pip_install resources

    # Replace shebang with virtualenv python
    inreplace libexec/"recon-ng", "#!/usr/bin/env python", "#!#{libexec}/bin/python"

    bin.install_symlink libexec/"recon-ng"
  end

  test do
    (testpath/"resource").write <<~EOS
      load brute_hosts
      show info
      exit
    EOS
    system "#{bin}/recon-ng", "-r", testpath/"resource"
  end
end
