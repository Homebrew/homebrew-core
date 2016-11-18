class ReconNg < Formula
  include Language::Python::Virtualenv

  desc "Web Reconnaissance Framework"
  homepage "https://bitbucket.org/LaNMaSteR53/recon-ng"
  url "https://bitbucket.org/LaNMaSteR53/recon-ng/get/v4.8.3.tar.gz"
  sha256 "067470f032f098a711f15c3294149cd42a0861625fe356698a2619ea665f3cb0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9785980483bc4e2ae51b6df112ada9873ffd21c12636b81ebe29009e5e16e97d" => :sierra
    sha256 "b268a6fc15098285c4f68eae481e741ac17fac9cf61991bdf0b6673607505cde" => :el_capitan
    sha256 "29dc6e6e032d3924648110736f2e137f1b7b54c7f842c934be9c586234b4ff6e" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

  ### setup_requires dependencies
  resource "dicttoxml" do
    url "https://files.pythonhosted.org/packages/92/14/29393b4913b53ac9b4fa5cfc84d426e85289ed4f59e21f5d990d453defbc/dicttoxml-1.6.6.tar.gz"
    sha256 "8229dcbadbe8a417b5e221b0bd56dff8a8ffd250951e6e95d51d5c5e2a77cc68"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/b3/e3/091c6489f0b573b8a4069ce956d037061ae9321401c89323386fe748dc9f/dnspython-1.12.0.zip"
    sha256 "63bd1fae61809eedb91f84b2185816fac1270ae51494fbdd36ea25f904a8502f"
  end

  resource "jsonrpclib" do
    url "https://files.pythonhosted.org/packages/4f/84/d07e0a8e0ff14388e864a3e5fa1e0c03766c754d480d84f875604dc8c379/jsonrpclib-0.1.3.tar.gz"
    sha256 "a594e702c35408ae5540086ab5bdea284fb27d09520898c381c5bbdbfceffbba"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/63/c7/4f2a2a4ad6c6fa99b14be6b3c1cece9142e2d915aa7c43c908677afc8fa4/lxml-3.4.4.tar.gz"
    sha256 "b3d362bac471172747cda3513238f115cbd6c5f8b8e6319bf6a97a7892724099"
  end

  resource "mechanize" do
    url "https://files.pythonhosted.org/packages/32/bc/d5b44fe4a3b5079f035240a7c76bd0c71a60c6082f4bfcb1c7585604aa35/mechanize-0.2.5.tar.gz"
    sha256 "2e67b20d107b30c00ad814891a095048c35d9d8cb9541801cebe85684cc84766"
  end

  resource "slowaes" do
    url "https://files.pythonhosted.org/packages/79/a4/c7dcbe89ec22a6985790bc0effb12bb8caef494fbac3c2bab86ae51a53ef/slowaes-0.1a1.tar.gz"
    sha256 "83658ae54cc116b96f7fdb12fdd0efac3a4e8c7c7064e3fac3f4a881aa54bf09"
  end

  resource "XlsxWriter" do
    url "https://files.pythonhosted.org/packages/75/46/f1552b4a4d6faa6ec39dc2ddcb56e6b9a2865f07b9e126b2144d9090f056/XlsxWriter-0.9.3.tar.gz"
    sha256 "19d2b5c0dd4d5fc00e8d7f164795f50e885b20d1cc27a3d04d5c7fec3c4d57f6"
  end

  resource "olefile" do
    url "https://files.pythonhosted.org/packages/8e/32/db0c062319061c6c38067823485ebc6252423cdc3c1d7dec798ad5c989f4/olefile-0.42.1.zip"
    sha256 "8a3226dba11349b51a2c6de6af0c889324201f14a8c30992b7877109090e36e0"
  end

  resource "PyPDF2" do
    url "https://files.pythonhosted.org/packages/b4/01/68fcc0d43daf4c6bdbc6b33cc3f77bda531c86b174cac56ef0ffdb96faab/PyPDF2-1.26.0.tar.gz"
    sha256 "e28f902f2f0a1603ea95ebe21dff311ef09be3d0f0ef29a3e44a932729564385"
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
    (testpath/"resource").write <<-EOF.undent
      load brute_hosts
      show info
      exit
    EOF
    system "#{bin}/recon-ng", "-r", testpath/"resource"
  end
end
