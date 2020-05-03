class Theharvester < Formula
  include Language::Python::Virtualenv

  desc "Gather materials from public sources (for pen testers)"
  homepage "http://www.edge-security.com/theharvester.php"
  url "https://github.com/laramies/theHarvester/archive/V3.1.tar.gz"
  sha256 "5157f61bdd8fa2a7e5f4c055709e251a1664a86b0265450e5a68d2cdf8c55c13"
  revision 1
  head "https://github.com/laramies/theHarvester.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "274398dbaf8d24f8b52d6aaa436081486d95839b3a7040ed40f8afe37d1184b4" => :catalina
    sha256 "a12701a839ff69050ab270b1e3b18758aa6d107cc30a6cc7b1c4ce9d0a2d8dc0" => :mojave
    sha256 "fa44985ba8c6761d27b5c26582dfc79e14ede1c55d9e320d843095b419acdece" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.8"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/e3/e8/b3212641ee2718d556df0f23f78de8303f068fe29cdaa7a91018849582fe/PyYAML-5.1.2.tar.gz"
    sha256 "01adf0b6c6f61bd11af6e10ca52b7d4057dd0be0343eb9283c878cf3af56aee4"
  end

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/30/2e/b86ce168485b68d40c6a810838669deacf0abf41845c383659c2b613e69f/aiodns-2.0.0.tar.gz"
    sha256 "815fdef4607474295d68da46978a54481dd1e7be153c7d60f9e72773cd38d77d"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/86/cd/495c68f0536dcd25f016e006731ba7be72e072280305ec52590012c1e6f2/beautifulsoup4-4.8.1.tar.gz"
    sha256 "6135db2ba678168c07950f9a16c4031822c6f4aec75a65e0a97bc5ca09789931"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/62/85/7585750fd65599e88df0fed59c74f5075d4ea2fe611deceb95dd1c2fb25b/certifi-2019.9.11.tar.gz"
    sha256 "e4f3620cfea4f83eedc95b24abd9cd56f3c4b146dd0177e83a21b4eb49e21e50"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/0d/aa/c5ac2f337d9a10ee95d160d47beb8d9400e1b2a46bb94990a0409fe6d133/cffi-1.13.1.tar.gz"
    sha256 "558b3afef987cf4b17abd849e7bedf64ee12b28175d564d05b628a0f9355599b"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ec/c5/14bcd63cb6d06092a004793399ec395405edf97c2301dfdc146dfbd5beed/dnspython-1.16.0.zip"
    sha256 "36c5e8e38d4369a08b6780b7f27d790a292b2b08eea01607865bf0936c558e01"
  end

  resource "gevent" do
    url "https://files.pythonhosted.org/packages/ed/27/6c49b70808f569b66ec7fac2e78f076e9b204db9cf5768740cff3d5a07ae/gevent-1.4.0.tar.gz"
    sha256 "1eb7fa3b9bd9174dfe9c3b59b7a09b768ecd496debfc4976a9530a3e15c990d1"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/f8/e8/b30ae23b45f69aa3f024b46064c0ac8e5fcb4f22ace0dca8d6f9c8bbe5e7/greenlet-0.4.15.tar.gz"
    sha256 "9416443e219356e3c31f1f918a91badf2e37acf297e2fa13d24d1cc2380f8fbc"
  end

  resource "grequests" do
    url "https://files.pythonhosted.org/packages/7e/80/39540c164bc4a6fd5bdafe4ab448752605bce4812b77702f81fd54fbbcc3/grequests-0.4.0.tar.gz"
    sha256 "8aeccc15e60ec65c7e67ee32e9c596ab2196979815497f85cf863465a1626490"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/85/3e/cf449cf1b5004e87510b9368e7a5f1acd8831c2d6691edd3c62a0823f98f/html5lib-1.0.1.tar.gz"
    sha256 "66cb0dcfdbbc4f9c3ba1a63fdb511ffdbd4f513b2b6d81b80cd26ce6b3fb3736"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/0c/13/7cbb180b52201c07c796243eeff4c256b053656da5cfe3916c3f5b57b3a0/netaddr-0.7.19.tar.gz"
    sha256 "38aeec7cdd035081d3a4c306394b19d677623bf76fa0913f6695127c7753aefd"
  end

  resource "plotly" do
    url "https://files.pythonhosted.org/packages/51/6d/835092e91c265d28f4bb94beda715b0182080f8e0344a6480bf4dc9d8522/plotly-4.2.1.tar.gz"
    sha256 "6650ddb4da3aa94dcaa32e0779e611c6b17f371b5250ffdbf5ece6d66ba4483b"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/85/de/cd46a73e43e206a6ad1e9cf9cc893c3ed1b21caf57f1e0a8d9a119d290eb/pycares-3.0.0.tar.gz"
    sha256 "b253f5dcaa0ac7076b79388a3ac80dd8f3bd979108f813baade40d3a9b8bf0bd"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/44/ef/beae4b4ef80902f22e3af073397f079c96969c69b2c7d52a57ea9ae61c9d/retrying-1.3.3.tar.gz"
    sha256 "08c039560a6da2fe4f2c426d0766e284d3b736e355f8dd24b37367b0bb41973b"
  end

  resource "shodan" do
    url "https://files.pythonhosted.org/packages/a5/8b/c62f16523a14ac8df38745b75b2d498566c6ad87d7339d25d489261320be/shodan-1.19.0.tar.gz"
    sha256 "9d8bb822738d02a63dbe890b46f511f0df13fd33a60b754278c3bf5dd5cf9fc4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/7f/4e/95a13527e18b6f1a15c93f1c634b86d5fa634c5619dce695f4e0cd68182f/soupsieve-1.9.4.tar.gz"
    sha256 "605f89ad5fdbfefe30cdc293303665eff2d188865d4dbe4eb510bba1edfbfce3"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/82/a8/60df592e3a100a1f83928795aca210414d72cebdc6e4e0c95a6d8ac632fe/texttable-1.6.2.tar.gz"
    sha256 "eff3703781fbc7750125f50e10f001195174f13825a92a45e9403037d539b4f4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ff/44/29655168da441dff66de03952880c6e2d17b252836ff1aa4421fba556424/urllib3-1.25.6.tar.gz"
    sha256 "9a107b99a5393caf59c7aa3c1249c16e6879447533d0887f4336dde834c7be86"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    venv = virtualenv_create(libexec/"venv", "python3")
    venv.pip_install resources

    libexec.install Dir["*"]
    (libexec/"theHarvester.py").chmod 0755
    (bin/"theharvester").write_env_script("#{libexec}/theHarvester.py", :PATH => "#{libexec}/venv/bin:$PATH")
  end

  test do
    output = shell_output("#{bin}/theharvester -d brew.sh -l 1 -b google 2>&1")
    assert_match "docs.brew.sh:", output
  end
end
