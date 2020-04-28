class RobotFramework < Formula
  include Language::Python::Virtualenv

  desc "Open source test framework for acceptance testing"
  homepage "https://robotframework.org/"
  url "https://github.com/robotframework/robotframework/archive/v3.2.tar.gz"
  sha256 "2a037c6bb40186e90fe576605070ba85dd911bb10077631eb77cd4c991c65ae7"
  head "https://github.com/robotframework/robotframework.git"

  bottle do
    cellar :any
    sha256 "bf03a1594e175378aa5734fcdff64bb416d493cfe26636f482981fb5b13400e7" => :catalina
    sha256 "30ecf2a2a030d35af96ac1baa8ad7ff877cb61846708a7ca088f6ff29ffc418b" => :mojave
    sha256 "dc8d70ee1a994c20b4201afb832f99c5416a06343759f8f10bec1ab12a441e78" => :high_sierra
    sha256 "efd370a66e69bc62b55e686519f3951a0d41e4f37eb6faf4dfcd9c097043cb5f" => :sierra
  end

  depends_on "openssl@1.1"
  depends_on "python@3.8"
  depends_on :x11

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/fa/aa/025a3ab62469b5167bc397837c9ffc486c42a97ef12ceaa6699d8f5a5416/bcrypt-3.1.7.tar.gz"
    sha256 "0b0069c752ec14172c5f78208f1863d7ad6755a6fae6fe76ec2c80d13be41e42"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/05/54/3324b0c46340c31b909fcec598696aaec7ddc8c18a63f2db352562d3354c/cffi-1.14.0.tar.gz"
    sha256 "2d384f4a127a15ba701207f7639d94106693b6cd64173d6c8988e2c25f3ac2b6"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/56/3b/78c6816918fdf2405d62c98e48589112669f36711e50158a0c15d804c30d/cryptography-2.9.2.tar.gz"
    sha256 "a0c30272fb4ddda5f5ffc1089d7405b7a71b0b0f51993cb4e5dbb4590b2fc229"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/ac/15/4351003352e11300b9f44a13576bff52dcdc6e4a911129c07447bda0a358/paramiko-2.7.1.tar.gz"
    sha256 "920492895db8013f6cc0179293147f830b8c7b21fdfc839b6bad760c27459d9f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/61/ab/2ac6dea8489fa713e2b4c6c5b549cc962dd4a842b5998d9e80cf8440b7cd/PyNaCl-1.3.0.tar.gz"
    sha256 "0c6100edd16fefd1557da078c7a31e7b7d7a52ce39fdca2bec29d4f7b6e7600c"
  end

  resource "robotframework-archivelibrary" do
    url "https://files.pythonhosted.org/packages/29/b6/bf5bd38d5764f6afaf17b0debef580aee9bfbd63ad77a0e215389691fdfb/robotframework-archivelibrary-0.4.0.tar.gz"
    sha256 "d18dd05a9d43decef1352a9a7601522639e4e6f02a084692b6392603c5f6c063"
  end

  resource "robotframework-selenium2library" do
    url "https://files.pythonhosted.org/packages/c4/7d/3c07081e7f0f1844aa21fd239a0139db4da5a8dc219d1e81cb004ba1f4e2/robotframework-selenium2library-3.0.0.tar.gz"
    sha256 "2a8e942b0788b16ded253039008b34d2b46199283461b294f0f41a579c70fda7"
  end

  resource "robotframework-seleniumlibrary" do
    url "https://files.pythonhosted.org/packages/ee/8b/1365ae004235bed3d0787bf98651b2e4416b07e8aa6cd5f8dcaa7fe1dd14/robotframework-seleniumlibrary-4.3.0.tar.gz"
    sha256 "b4a3a58d3c240a2004d7436e4806b5de669db329cd6fd264f45b65943c5140c4"
  end

  resource "robotframework-sshlibrary" do
    url "https://files.pythonhosted.org/packages/5e/a3/25010fc4a2c126e1b5dcd1d08d55653aba819509c42d210e4dfbc2f1e844/robotframework-sshlibrary-3.4.0.tar.gz"
    sha256 "21fa0183776e6061366f517765db479aaa634b707f3dd9d90ef6972adae6a755"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/05/e0/ac4169e773e12a08d941ca3c006cb8c91bee9d6d80328a15af850b5e7480/scp-0.13.2.tar.gz"
    sha256 "ef9d6e67c0331485d3db146bf9ee9baff8a48f3eb0e6c08276a8584b13bf34b3"
  end

  resource "selenium" do
    url "https://files.pythonhosted.org/packages/ed/9c/9030520bf6ff0b4c98988448a93c04fcbd5b13cd9520074d8ed53569ccfe/selenium-3.141.0.tar.gz"
    sha256 "deaf32b60ad91a4611b98d8002757f29e6f2c2d5fcaf202e1c9ad06d6772300d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz"
    sha256 "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"HelloWorld.robot").write <<~EOS
      *** Settings ***
      Library         HelloWorld.py

      *** Test Cases ***
      HelloWorld
          Hello World
    EOS

    (testpath/"HelloWorld.py").write <<~EOS
      def hello_world():
          print("HELLO WORLD!")
    EOS
    system bin/"robot", testpath/"HelloWorld.robot"
  end
end
