class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from http://svtplay.se"
  homepage "https://svtplay-dl.se"
  url "https://pypi.python.org/packages/a0/a0/56996a5ec98d5d28b37d8c80bde33db2905286df1aed0a3ad2b1b6d53a97/svtplay-dl-1.4.tar.gz"
  sha256 "dc8561d337f5e38cbc41633ac6e916ceb5a9b63a1771e166f569ad8a271b798b"

  bottle do
    cellar :any
    sha256 "cbffb67c1a9efcdaf66702907ffcada0de3020b062ef4922e1259d4e2e0f25f4" => :el_capitan
    sha256 "6a3436457414b2db4989fba72c14f926036133e65822dc033640a93485ee55d3" => :yosemite
    sha256 "b2a4b0494fabfc74a4742fc9c229e060192373b4f1d7bd1e9007a89dde8e7327" => :mavericks
  end

  depends_on "rtmpdump"
  depends_on "openssl"

  # for request security
  resource "cffi" do
    url "https://files.pythonhosted.org/packages/b8/21/9d6f08d2d36a0a8c84623646b4ed5a07023d868823361a086b021fb21172/cffi-1.8.2.tar.gz"
    sha256 "2b636db1a179439d73ae0a090479e179a43df5d4eddc7e4c4067f960d4038530"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/6e/96/b8dab146e8be98061dae07e127f80cffa3061ab0e8da0d3d42f3308c6e91/cryptography-1.5.tar.gz"
    sha256 "52f47ec9a57676043f88e3ca133638790b6b71e56e8890d9d7f3ae4fcd75fa24"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/fb/84/8c27516fbaa8147acd2e431086b473c453c428e24e8fb99a1d89ce381851/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/bb/26/3b64955ff73f9e3155079b9ed31812afdfa5333b5c76387454d651ef593a/ipaddress-1.0.17.tar.gz"
    sha256 "3a21c5a15f433710aaa26f1ae174b615973a25182006ae7f9c26de151cd51716"
  end

  resource "ndg-httpsclient" do
    url "https://files.pythonhosted.org/packages/a2/a7/ad1c1c48e35dc7545dab1a9c5513f49d5fa3b5015627200d2be27576c2a0/ndg_httpsclient-0.4.2.tar.gz"
    sha256 "580987ef194334c50389e0d7de885fccf15605c13c6eecaabd8d6c43768eb8ac"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/6d/31/666614af3db0acf377876d48688c5d334b6e493b96d21aa7d332169bee50/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/15/1e/79c75db50e57350a7cefb70b110255757e9abd380a50ebdc0cfd853b7450/pyOpenSSL-16.1.0.tar.gz"
    sha256 "88f7ada2a71daf2c78a4f139b19d57551b4c8be01f53a1cb5c86c2f3bf01355f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  ########

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats; <<-EOS.undent
    To use post-processing options:
      `brew install ffmpeg` or `brew install libav`.
  EOS
  end

  test do
    system bin/"svtplay-dl", "-g", "http://tv.aftonbladet.se/abtv/articles/121638"
  end
end
