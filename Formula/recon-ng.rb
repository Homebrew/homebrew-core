class ReconNg < Formula
  include Language::Python::Virtualenv

  desc "Web Reconnaissance Framework"
  homepage "https://bitbucket.org/LaNMaSteR53/recon-ng"
  url "https://bitbucket.org/LaNMaSteR53/recon-ng/get/v4.9.4.tar.gz"
  sha256 "f443616351fb9dd119a870b637bdf7be0fb3a9fac6eb5a640b9d5414a63d2160"

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
    url "https://files.pythonhosted.org/packages/4b/12/c1fbf4971fda0e4de05565694c9f0c92646223cff53f15b6eb248a310a62/Flask-1.0.2.tar.gz"
    sha256 "2271c0070dbcb5275fad4a82e29f23ab92682dc45f9dfbc22c02ba9b9322ce48"
  end

  resource "jsonrpclib" do
    url "https://files.pythonhosted.org/packages/a9/0a/69b6b794d7b086793683743df2f6d0a4fcf97613a95a39cfc74b78f2adb7/jsonrpclib-0.1.7.tar.gz"
    sha256 "7f50239d53b5e95b94455d5e1adae70592b5b71f0e960d3bbbfbb125788e6f0b"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/4b/20/ddf5eb3bd5c57582d2b4652b4bbcf8da301bdfe5d805cb94e805f4d7464d/lxml-4.2.5.tar.gz"
    sha256 "36720698c29e7a9626a0dc802ef8885f8f0239bfd1689628ecd459a061f2807f"
  end

  resource "mechanize" do
    url "https://files.pythonhosted.org/packages/ef/be/4c433dfa7703c0fa81ca3a88afe74b2b9e2b23e664479a4913ecefe7f8ca/mechanize-0.3.7.tar.gz"
    sha256 "ee66e1a6af790898894dd0318914ced413d94f46a54f881eb337081ff9702cd2"
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
    url "https://files.pythonhosted.org/packages/0c/08/69581af3c4807d2b8bac47251c80343161b9f315a7f91fb703aa865302d9/XlsxWriter-1.1.2.tar.gz"
    sha256 "ae22658a0fc5b9e875fa97c213d1ffd617d86dc49bf08be99ebdac814db7bf36"
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
