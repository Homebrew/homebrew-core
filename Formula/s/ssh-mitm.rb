class SshMitm < Formula
  include Language::Python::Virtualenv

  desc "SSH server for security audits and malware analysis"
  homepage "https://docs.ssh-mitm.at"
  url "https://files.pythonhosted.org/packages/dc/15/b3b4189bcd5ba6a86e65d72689a980eb66a67a4a6bccdc1639b9251cd29a/ssh_mitm-4.1.1.tar.gz"
  sha256 "db61c3d33e4515bde82118e9f62dd3d25dbf35718005af16b30316dfa0be7b4f"
  license "GPL-3.0-only"
  head "https://github.com/ssh-mitm/ssh-mitm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ef44cda2dd3d934893a1d62473a689e0e8400bc2174f943f7adb98b2f3248dd7"
    sha256 cellar: :any,                 arm64_ventura:  "75c75cb175c2d9f29a95bcb924409f09f44f03407891f3c6f34cabd025c3522a"
    sha256 cellar: :any,                 arm64_monterey: "6023c376f2559861ab8121dff2b1f872c89044d654bade57b2184b62b3219d1b"
    sha256 cellar: :any,                 sonoma:         "402c84a3b7b4730da1b8c444548215270cc52e61cbc947299e0a9ac83258a53b"
    sha256 cellar: :any,                 ventura:        "e8ad2860bca8d53caba09c56a6466408e4ad62ca12af33b34ece6d50829a65ff"
    sha256 cellar: :any,                 monterey:       "bb04d30ddcc4b4ca5e6bf495b326c8372fc4e471864767f38639b03b3d3693e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceb68e14347fc6f094cc4c20d2ffbd8639147201c8362f1108388940a7dc24c3"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-argcomplete"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "colored" do
    url "https://files.pythonhosted.org/packages/d2/ce/cca52eb08fdb44fd99e0dd16de52228cb4ef108d7aff7c3bc359bc9b103c/colored-2.2.3.tar.gz"
    sha256 "1905ae45fa2b7fd63a8b4776586e63aeaba4df8db225b72b78fd167408558983"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/ff/7b/ba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1/ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/44/03/158ae1dcb950bd96f04038502238159e116fafb27addf5df1ba35068f2d6/paramiko-3.3.1.tar.gz"
    sha256 "6a3777a961ac86dbef375c5f5b8d50014a1a96d0fd7f054a43bc880134b0ff77"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "python-json-logger" do
    url "https://files.pythonhosted.org/packages/4f/da/95963cebfc578dabd323d7263958dfb68898617912bb09327dd30e9c8d13/python-json-logger-2.0.7.tar.gz"
    sha256 "23e7ec02d34237c5aa1e29a070193a4ea87583bb4e7f8fd06d3de8264c4b2e1c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "sshpubkeys" do
    url "https://files.pythonhosted.org/packages/a3/b9/e5b76b4089007dcbe9a7e71b1976d3c0f27e7110a95a13daf9620856c220/sshpubkeys-3.3.1.tar.gz"
    sha256 "3020ed4f8c846849299370fbe98ff4157b0ccc1accec105e07cfa9ae4bb55064"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "pty"
    port = free_port

    stdout, _stdin, _pid = PTY.spawn("#{bin}/ssh-mitm server --listen-port #{port}")
    assert_match "SSH-MITM - ssh audits made simple", stdout.readline
  end
end
