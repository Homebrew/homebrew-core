class Thumbor < Formula
  include Language::Python::Virtualenv

  desc "Smart imaging service with on-demand crop, resizing and flipping"
  homepage "http://thumbor.readthedocs.io"
  url "https://files.pythonhosted.org/packages/44/1f/5b0c3bcc760b01653e442ce3f1706652ecdf7e644f7979779fd33d450184/thumbor-6.2.0.tar.gz"
  sha256 "3c569dccd663f6adb6eaee01f8bc8158dd8e64714c40a64679a9ec2700aab923"

  depends_on :python
  depends_on "homebrew/dupes/zlib"
  depends_on "homebrew/science/opencv"
  depends_on "homebrew/python/pillow"

  resource "backports_abc" do
    url "https://files.pythonhosted.org/packages/68/3c/1317a9113c377d1e33711ca8de1e80afbaf4a3c950dd0edfaf61f9bfe6d8/backports_abc-0.5.tar.gz"
    sha256 "033be54514a03e255df75c5aee8f9e672f663f93abb723444caec8fe43437bde"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4f/75/e1bc6e363a2c76f8d7e754c27c437dbe4086414e1d6d2f6b2a3e7846f22b/certifi-2016.9.26.tar.gz"
    sha256 "8275aef1bbeaf05c53715bfc5d8569bd1e04ca1e8e69608cc52bcaac2604eb19"
  end

  resource "derpconf" do
    url "https://files.pythonhosted.org/packages/98/2d/4703d2f342faf2d66970f67d7664f24facca299b16983365f3c8ee20a0cd/derpconf-0.8.1.tar.gz"
    sha256 "3131c2a37a0b918285a95790b2a61772c82c7c2e463f217a3d01c5e6e381e8f5"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "libthumbor" do
    url "https://files.pythonhosted.org/packages/99/db/28a9bc9088de0971b0a20cd041f3e65fe03e7e303d627de2077a9b7151ee/libthumbor-1.3.2.tar.gz"
    sha256 "2ba48729e9e52fed235c6948f40ffd5c59c9bc74593ccf4d988972e4f4d750ee"
  end

  resource "argparse" do
    url "https://pypi.python.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "pexif" do
    url "https://files.pythonhosted.org/packages/ba/a8/a710c88bc159de6b907c9094250e304182d43c3e5207c8e61f325e8e6e6f/pexif-0.15.tar.gz"
    sha256 "45a3be037c7ba8b64bbfc48f3586402cc17de55bb9d7357ef2bc99954a18da3f"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/12/3f/557356b60d8e59a1cce62ffc07ecc03e4f8a202c86adae34d895826281fb/pycurl-7.43.0.tar.gz"
    sha256 "aa975c19b79b6aa6c0518c0cc2ae33528900478f0b500531dbcdbf05beec584c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/d0/e1/aca6ef73a7bd322a7fc73fd99631ee3454d4fc67dc2bee463e2adf6bb3d3/pytz-2016.10.tar.bz2"
    sha256 "7016b2c4fa075c564b81c37a252a5fccf60d8964aa31b7f5eae59aeb594ae02b"
  end

  resource "singledispatch" do
    url "https://files.pythonhosted.org/packages/d9/e9/513ad8dc17210db12cb14f2d4d190d618fb87dd38814203ea71c87ba5b68/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "statsd" do
    url "https://files.pythonhosted.org/packages/89/1e/365c87f21df573198a6e889e243fddb66755087987000a07177e80bfffea/statsd-3.2.1.tar.gz"
    sha256 "3fa92bf0192af926f7a0d9be031fe3fd0fbaa1992d42cf2f07e68f76ac18288e"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/1e/7c/ea047f7bbd1ff22a7f69fe55e7561040e3e54d6f31da6267ef9748321f98/tornado-4.4.2.tar.gz"
    sha256 "2898f992f898cd41eeb8d53b6df75495f2f423b6672890aadaf196ea1448edcc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"thumbor-config"
  end
end
