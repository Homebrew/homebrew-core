class ReconNg < Formula
  include Language::Python::Virtualenv

  desc "Web Reconnaissance Framework"
  homepage "https://bitbucket.org/LaNMaSteR53/recon-ng"
  url "https://bitbucket.org/LaNMaSteR53/recon-ng/get/v4.9.6.tar.gz"
  sha256 "0192a9882bb9800f2177fcdb31cda8031bbc3895db9fe4a0966ebdd771b66915"

  bottle do
    cellar :any_skip_relocation
    sha256 "18b3feb82b8eea90e49856c098ca66ea10f957eaaeae1ff7813eccbeb1265996" => :mojave
    sha256 "d23885588e18d5b47d7175f37d03de1aaef5818fb548d42c00e922339602b182" => :high_sierra
    sha256 "9cc593ac5d73a9b995a419bf37632ff375f206aab63a6415409f18ce151c36b9" => :sierra
  end

  # Dependency "mechanize" only support Python 2
  depends_on "python@2" # does not support Python 3

  ### setup_requires dependencies
  resource "dicttoxml" do
    url "https://files.pythonhosted.org/packages/74/36/534db111db9e7610a41641a1f6669a964aacaf51858f466de264cc8dcdd9/dicttoxml-1.7.4.tar.gz"
    sha256 "ea44cc4ec6c0f85098c57a431a1ee891b3549347b07b7414c8a24611ecf37e45"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ec/c5/14bcd63cb6d06092a004793399ec395405edf97c2301dfdc146dfbd5beed/dnspython-1.16.0.zip"
    sha256 "36c5e8e38d4369a08b6780b7f27d790a292b2b08eea01607865bf0936c558e01"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/e9/96/8f6d83828a77306a119e12b215a7b0637c955b408fb1c161311a6891b958/Flask-1.0.3.tar.gz"
    sha256 "ad7c6d841e64296b962296c2c2dabc6543752985727af86a975072dea984b6f3"
  end

  resource "jsonrpclib" do
    url "https://files.pythonhosted.org/packages/a9/0a/69b6b794d7b086793683743df2f6d0a4fcf97613a95a39cfc74b78f2adb7/jsonrpclib-0.1.7.tar.gz"
    sha256 "7f50239d53b5e95b94455d5e1adae70592b5b71f0e960d3bbbfbb125788e6f0b"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/da/b5/d3e0d22649c63e92cb0902847da9ae155c1e801178ab5d272308f35f726e/lxml-4.3.4.tar.gz"
    sha256 "3ce1c49d4b4a7bc75fb12acb3a6247bb7a91fe420542e6d671ba9187d12a12c2"
  end

  resource "mechanize" do
    url "https://files.pythonhosted.org/packages/79/6b/c256ffe2abd560a2857bd66131e01ddfb4b123510a0100a495ded8f191cc/mechanize-0.4.2.tar.gz"
    sha256 "b680ca1b4fabe5ef52024d120f40b8e2ed7d175ed4d67225d2c477dac7c7a58b"
  end

  resource "olefile" do
    url "https://files.pythonhosted.org/packages/34/81/e1ac43c6b45b4c5f8d9352396a14144bba52c8fec72a80f425f6a4d653ad/olefile-0.46.zip"
    sha256 "133b031eaf8fd2c9399b78b8bc5b8fcbe4c31e85295749bb17a87cba8f3c3964"
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
    url "https://files.pythonhosted.org/packages/39/2f/9018f9980416afaef326c2399c2c583f292cfb4a15f0b67059f4c0f9aa99/XlsxWriter-1.1.8.tar.gz"
    sha256 "5ec6aa71f6ae4b6298376d8b6a56ca9cdcb8b80323a444212226447aed4fa10f"
  end

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

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
