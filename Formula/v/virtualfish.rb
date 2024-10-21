class Virtualfish < Formula
  include Language::Python::Virtualenv

  desc "Python virtual environment manager for the fish shell"
  homepage "https://virtualfish.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/1f/4e/343d044d61e80a44163d15ad2f6ca20eca0cb4fef4058caf8e5e55fc3dd9/virtualfish-2.5.9.tar.gz"
  sha256 "9beada15b00c5b38c700ed8dfd76fe35ad0c716dec391536cc322ddd1bccf5e2"
  license "MIT"
  head "https://github.com/justinmayer/virtualfish.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a73cbe3f0c1e23e92d210d78d64aa2b46c3e367dae4725787d06a837c58cf38d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c3ce3408e5bb7842c88929b4262e95374f4e26533e1fb54278b8a96d8a1dbd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "67deb36dbcafcaeaf481e1c9141aab9e5819ceba45739bc09f4ce746b2517242"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b05ac61a3c855bb3c91af9dd4929464fc2585d715832ba459e81f7c11b34375"
    sha256 cellar: :any_skip_relocation, ventura:       "20e7e201bfe054eb0a77913ee1b67ca180afefc9d4ee2b1400f23baa13fbf85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f311e893a5ac71c779f94120b38fe58d3c0ee283c85efdd4bd2a4c8d255380d"
  end

  depends_on "fish"
  depends_on "python@3.13"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/06/ae/f8e03746f0b62018dcf1120f5ad0a1db99e55991f2cda0cf46edc8b897ea/filelock-3.14.0.tar.gz"
    sha256 "6ea72da3be9b8c82afd3edcf99f2fffbb5076335a5ae4d03248bb5b6c3eae78a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "pkgconfig" do
    url "https://files.pythonhosted.org/packages/c4/e0/e05fee8b5425db6f83237128742e7e5ef26219b687ab8f0d41ed0422125e/pkgconfig-1.5.5.tar.gz"
    sha256 "deb4163ef11f75b520d822d9505c1f462761b4309b1bb713d08689759ea8b899"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b2/e4/2856bf61e54d7e3a03dd00d0c1b5fa86e6081e8f262eb91befbe64d20937/platformdirs-4.2.1.tar.gz"
    sha256 "031cd18d4ec63ec53e82dceaac0417d218a6863f7745dfcc9efe7793b7039bdf"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/93/9f/97beb3dd55a764ac9776c489be4955380695e8d7a6987304e58778ac747d/virtualenv-20.26.1.tar.gz"
    sha256 "604bfdceaeece392802e6ae48e69cec49168b9c5f4a44e483963f9242eb0e78b"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      To activate virtualfish, run the following in a fish shell:
        vf install
    EOS
  end

  test do
    # Pre-create .virtualenvs to avoid interactive prompt
    (testpath/".virtualenvs").mkpath

    # Run `vf install` in the test environment, adds vf as function
    refute_path_exists testpath/".config/fish/conf.d/virtualfish-loader.fish"
    assert_match "VirtualFish is now installed!", shell_output("fish -c '#{bin}/vf install'")
    assert_path_exists testpath/".config/fish/conf.d/virtualfish-loader.fish"

    # Add virtualenv to prompt so virtualfish doesn't link to prompt doc
    (testpath/".config/fish/functions/fish_prompt.fish").write(<<~EOS)
      function fish_prompt --description 'Test prompt for virtualfish'
        echo -n -s (pwd) 'VIRTUAL_ENV=' (basename "$VIRTUAL_ENV") '>'
      end
    EOS

    # Create a virtualenv 'new_virtualenv'
    refute_path_exists testpath/".virtualenvs/new_virtualenv/pyvenv.cfg"
    system "fish", "-c", "vf new new_virtualenv"
    assert_path_exists testpath/".virtualenvs/new_virtualenv/pyvenv.cfg"

    # The virtualenv is listed
    assert_match "new_virtualenv", shell_output('fish -c "vf ls"')

    # cannot delete virtualenv on sequoia, upstream bug report, https://github.com/justinmayer/virtualfish/issues/250
    return if OS.mac? && MacOS.version >= :sequoia

    # Delete the virtualenv
    system "fish", "-c", "vf rm new_virtualenv"
    refute_path_exists testpath/".virtualenvs/new_virtualenv/pyvenv.cfg"
  end
end
