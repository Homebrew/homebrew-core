class SvtplayDl < Formula
  include Language::Python::Virtualenv

  desc "Download videos from http://svtplay.se"
  homepage "https://svtplay-dl.se"
  url "https://pypi.python.org/packages/be/0c/8d31c66b650c09194f5e2e00cbf18b9d80eae9ed16db6f550d2493fcc809/svtplay-dl-1.9.tar.gz"
  sha256 "bd2a14fa2abe8a80df4543ff848010a883c9ddaeaffea6948690ccef62e40204"

  bottle do
    cellar :any
    sha256 "9c8e3138fa9608b45c2c815c8144a2b1d54a029f000d1e896a0c87327eb81e6c" => :sierra
    sha256 "e7e3acc3a067cd2bcadc57652a391472b36d5804540884660c067136a3dc4ca9" => :el_capitan
    sha256 "f3973c57afe94ea1d99893532d7af3cfcc5a8ddc5f6c861308844024d8179363" => :yosemite
  end

  depends_on "rtmpdump"
  depends_on "openssl"

  # for request security
  resource "cffi" do
    url "https://pypi.python.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "cryptography" do
    url "https://pypi.python.org/packages/82/f7/d6dfd7595910a20a563a83a762bf79a253c4df71759c3b228accb3d7e5e4/cryptography-1.7.1.tar.gz"
    sha256 "953fef7d40a49a795f4d955c5ce4338abcec5dea822ed0414ed30348303fdb4c"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "idna" do
    url "https://pypi.python.org/packages/94/fe/efb1cb6f505e1a560b3d080ae6b9fddc11e7c542d694ce4635c49b1ccdcb/idna-2.2.tar.gz"
    sha256 "0ac27740937d86850010e035c6a10a564158a5accddf1aa24df89b0309252426"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
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
    url "https://pypi.python.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/b6/61/7b374462d5b6b1d824977182db287758d549d8680444bad8d530195acba2/requests-2.12.5.tar.gz"
    sha256 "d902a54f08d086a7cc6e58c20e2bb225b1ae82c19c35e5925269ee94fb9fce00"
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
