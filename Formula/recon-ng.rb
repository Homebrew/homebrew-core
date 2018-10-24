class ReconNg < Formula
  include Language::Python::Virtualenv

  desc "Web Reconnaissance Framework"
  homepage "https://bitbucket.org/LaNMaSteR53/recon-ng"
  url "https://bitbucket.org/LaNMaSteR53/recon-ng/get/v4.9.3.tar.gz"
  sha256 "e841bc43c5097f3506d548d23a538411f9e5712ec5dbdb2be2d3fb0a863f7faf"

  bottle do
    cellar :any_skip_relocation
    sha256 "c97683d12457024ec25776ac3e1859879e4f5142b524da76f665d7fd3ee00e76" => :mojave
    sha256 "1f64d3f5bbfb90e586bf9330544206b38006a4a71ce84bd96f5d9214bd39d6f1" => :high_sierra
    sha256 "2c68dcdf33ff768dca3197e71836fdf24fc1a7078d06590c46ab1e9a64cac6ad" => :sierra
    sha256 "6ec0a0c8e4b4340e0e53baa5e944c61e3096caa1391fce82fd4763584c67bc98" => :el_capitan
  end

  # Dependency "mechanize" only support Python 2
  depends_on "python@2" # does not support Python 3

  ### setup_requires dependencies
  resource "dicttoxml" do
    url "https://files.pythonhosted.org/packages/74/36/534db111db9e7610a41641a1f6669a964aacaf51858f466de264cc8dcdd9/dicttoxml-1.7.4.tar.gz"
    sha256 "ea44cc4ec6c0f85098c57a431a1ee891b3549347b07b7414c8a24611ecf37e45"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/e4/96/a598fa35f8a625bc39fed50cdbe3fd8a52ef215ef8475c17cabade6656cb/dnspython-1.15.0.zip"
    sha256 "40f563e1f7a7b80dc5a4e76ad75c23da53d62f1e15e6e517293b04e1f84ead7c"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/eb/12/1c7bd06fcbd08ba544f25bf2c6612e305a70ea51ca0eda8007344ec3f123/Flask-0.12.2.tar.gz"
    sha256 "49f44461237b69ecd901cc7ce66feea0319b9158743dd27a2899962ab214dac1"
  end

  resource "jsonrpclib" do
    url "https://files.pythonhosted.org/packages/a9/0a/69b6b794d7b086793683743df2f6d0a4fcf97613a95a39cfc74b78f2adb7/jsonrpclib-0.1.7.tar.gz"
    sha256 "7f50239d53b5e95b94455d5e1adae70592b5b71f0e960d3bbbfbb125788e6f0b"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e1/4c/d83979fbc66a2154850f472e69405572d89d2e6a6daee30d18e83e39ef3a/lxml-4.1.1.tar.gz"
    sha256 "940caef1ec7c78e0c34b0f6b94fe42d0f2022915ffc78643d28538a5cfd0f40e"
  end

  resource "mechanize" do
    url "https://files.pythonhosted.org/packages/a7/ac/7f54bcf39b62cd56dec461f4c5e2d7c096508ab2b283c7ee099a466e1b9f/mechanize-0.3.6.tar.gz"
    sha256 "654e705157156c1f316601ea4f7ab27e96713a8a4dabe1604e6cc8d48e0aa1e8"
  end

  resource "olefile" do
    url "https://files.pythonhosted.org/packages/d3/8a/e0f0e56d6a542dd987f9290ef7b5164636ee597ce8c2932c19c78292d5ec/olefile-0.45.1.zip"
    sha256 "2b6575f5290de8ab1086f8c5490591f7e0885af682c7c1793bdaf6e64078d385"
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
    url "https://files.pythonhosted.org/packages/e4/63/e53deacc293c7fadf95b840471f4bd56573d084af993e6aeeee2d5f1bd32/XlsxWriter-1.0.2.tar.gz"
    sha256 "a26bbbafff88abffce592ffd5dfaa4c9f08dc44ef4afbf45c70d3e270325f856"
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
