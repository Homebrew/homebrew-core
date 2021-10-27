class Stormssh < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to manage your ssh connections"
  homepage "https://github.com/emre/storm"
  url "https://files.pythonhosted.org/packages/0a/18/85d12be676ae0c1d98173b07cc289bbf9e0c67d6c7054b8df3e1003bf992/stormssh-0.7.0.tar.gz"
  sha256 "8d034dcd9487fa0d280e0ec855d08420f51d5f9f2249f932e3c12119eaa53453"
  license "MIT"
  revision 7
  head "https://github.com/emre/storm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a75b8177eb8ca535665d4e6198b936b0c709c91a8bbc2274f49bbd22d394f677"
    sha256 cellar: :any,                 arm64_big_sur:  "c9cc953d93d1534a753f07f088194514d75fc220f3ad34fc6a0e6324be1604ad"
    sha256 cellar: :any,                 monterey:       "22a0178c38fd3644223aac5b7ba6f4e0c766e7aa6fef706a8b703eb9f76d6d5c"
    sha256 cellar: :any,                 big_sur:        "ad691ed14359decd9760497aed20b6b0f6d4e54c978e3c191a52b59a8331bf32"
    sha256 cellar: :any,                 catalina:       "d32420400831851cfc19a8512008eec8cf9d69f60b028a46455394408be367c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c0a72be0bad9b3a4a023974ca99c0dea3579d3ba9d00a4c9d0d97201eed75f3"
  end

  depends_on "rust" => :build
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  conflicts_with "storm", because: "both install 'storm' binary"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/91/90b8d4cd611ac2aa526290ae4b4285aa5ea57ee191c63c2f3d04170d7683/cryptography-35.0.0.tar.gz"
    sha256 "9933f28f70d0517686bd7de36166dda42094eac49415459d9bdf5e7df3e0086d"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/95/40/b976286b5e7ba01794a7e7588e7e7fa27fb16c6168fa849234840bf0f61d/Flask-2.0.2.tar.gz"
    sha256 "7b2fb8e934ddd50731893bdcdb00fc8c0315916f9fcd50d22c7cc1a95ab634e2"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/58/66/d6c5859dcac92b442626427a8c7a42322068c5cd5d4a463ce78b93f730b7/itsdangerous-2.0.1.tar.gz"
    sha256 "9e724d68fc22902a1435351f84c3fb8623f303fffcc566a4cb952df8c572cff0"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/f8/86/7c0eb6e8b05385d1ce682abc0f994abd1668e148fb52603fa86e15d4c110/Jinja2-3.0.2.tar.gz"
    sha256 "827a0e32839ab1600d4eb1c4c33ec5a8edfbc5cb42dafa13b81f182f97784b45"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/dd/67/6b3a5f3d730b15b5ff77d13e6f05f9189ae44d8a8bad4967d16694eaac8b/paramiko-2.8.0.tar.gz"
    sha256 "e673b10ee0f1c80d46182d3af7751d033d9b573dd7054d2d0aa46be186c3c1d2"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/83/3c/ecdb36f49ab06defb0d5a466cfeb4ae90a55d02cfef379f781da2801a45d/Werkzeug-2.0.2.tar.gz"
    sha256 "aa2bb6fc8dee8d6c504c0ac1e7f5f7dc5810a9903e793b6f715a9f015bdadb9a"
  end

  # Support python 3.10, remove when upstream patch is merged/released
  # https://github.com/emre/storm/pull/176
  patch do
    url "https://github.com/emre/storm/commit/5a4306b90060f6109611df49ac480f1300e35acd.patch?full_index=1"
    sha256 "38e44cff45aef6549574777fb4fdbc065604d0a8918d26a3de02f1570ae1bb92"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    sshconfig_path = (testpath/"sshconfig")
    touch sshconfig_path

    system bin/"storm", "add", "--config", "sshconfig", "aliastest", "user@example.com:22"

    expected_output = <<~EOS
      Host aliastest
          hostname example.com
          user user
          port 22
    EOS
    assert_equal expected_output, sshconfig_path.read
  end
end
