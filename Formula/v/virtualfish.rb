class Virtualfish < Formula
  include Language::Python::Virtualenv

  desc "Python virtual environment manager for the fish shell"
  homepage "https://virtualfish.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/54/2f/a7800ae09a689843b62b3eb423d01a90175be5795b66ac675f6f45349ca9/virtualfish-2.5.5.tar.gz"
  sha256 "6b654995f151af8fca62646d49a62b5bf646514250f1461df6d42147995a0db2"
  license "MIT"
  head "https://github.com/justinmayer/virtualfish.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "869c8a12184ad98701a95942837e86ba30a8651f84f482f15c8d49ff6f42732e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "283a6425d3bd1d9ca8b2d212923b854683abf4137513d3e31d63fdd8739d52ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dcedf8f5e261b6f571dd62f9cb3cce49446dce451eeaaffb0918982815671f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "9973b9fb1e8178283ab5fc0424f28deaaa7130cfd7edcf90ed2e2adf59ddc07a"
    sha256 cellar: :any_skip_relocation, ventura:        "709e6684df5d34e84e37508e8f3640ce8818db3c726b14fa3d1ab142d672e354"
    sha256 cellar: :any_skip_relocation, monterey:       "2d18040a59d0c4d2279a1cf6d2d1cc5e98067a143854b3b196b287d8bb80e705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ceff02ecc7db355983c71e51f6dd4ca74129bfd8c19d5961021162c9611200e"
  end

  depends_on "fish"
  depends_on "python-packaging"
  depends_on "python-psutil"
  depends_on "python-setuptools"
  depends_on "python@3.12"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d5/71/bb1326535231229dd69a9dd2e338f6f54b2d57bd88fc4a52285c0ab8a5f6/filelock-3.12.4.tar.gz"
    sha256 "2e6f249f1f3654291606e046b09f1fd5eac39b360664c27f5aad072012f8bcbd"
  end

  resource "pkgconfig" do
    url "https://files.pythonhosted.org/packages/c4/e0/e05fee8b5425db6f83237128742e7e5ef26219b687ab8f0d41ed0422125e/pkgconfig-1.5.5.tar.gz"
    sha256 "deb4163ef11f75b520d822d9505c1f462761b4309b1bb713d08689759ea8b899"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/d3/50/fa955bbda25c0f01297843be105f9d022f461423e69a6ab487ed6cabf75d/virtualenv-20.24.5.tar.gz"
    sha256 "e8361967f6da6fbdf1426483bfe9fca8287c242ac0bc30429905721cefbff752"
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

    # Delete the virtualenv
    system "fish", "-c", "vf rm new_virtualenv"
    refute_path_exists testpath/".virtualenvs/new_virtualenv/pyvenv.cfg"
  end
end
