class Virtualfish < Formula
  include Language::Python::Virtualenv

  desc "Python virtual environment manager for the fish shell"
  homepage "https://virtualfish.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/1f/4e/343d044d61e80a44163d15ad2f6ca20eca0cb4fef4058caf8e5e55fc3dd9/virtualfish-2.5.9.tar.gz"
  sha256 "9beada15b00c5b38c700ed8dfd76fe35ad0c716dec391536cc322ddd1bccf5e2"
  license "MIT"
  revision 1
  head "https://github.com/justinmayer/virtualfish.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3a88c4f99fcec7089fea68596b5bcfd8a958b0efbf976ac24382e7bd937ecb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a7c92e54504109326a36795da0a495f1706780401a87d42f06f7e4d3836c1ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bf883dd8de5a67da56d7d9440e28232bd206280894e1b8bc1405ba51a4c307b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7968863cc9ebad65cdb0674406f5f1b3b82cefeb8a7e893e0177de6a13f0f3cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dda22263a86449d56e0457dc078f0a76dfc7457375bbb07ef5be4713df9bccf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48eef847a95a8e50067fd8a94a3477a232413b1b0af6e389b9d5cdcb16a2b9e0"
  end

  depends_on "fish"
  depends_on "python@3.14"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/96/8e/709914eb2b5749865801041647dc7f4e6d00b549cfe88b65ca192995f07c/distlib-0.4.0.tar.gz"
    sha256 "feec40075be03a04501a973d81f633735b4b69f98b05450592310c0f401a4e0d"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/58/46/0028a82567109b5ef6e4d2a1f04a583fb513e6cf9527fcdd09afd817deeb/filelock-3.20.0.tar.gz"
    sha256 "711e943b4ec6be42e1d4e6690b48dc175c822967466bb31c0c293f34334c13f4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pkgconfig" do
    url "https://files.pythonhosted.org/packages/c4/e0/e05fee8b5425db6f83237128742e7e5ef26219b687ab8f0d41ed0422125e/pkgconfig-1.5.5.tar.gz"
    sha256 "deb4163ef11f75b520d822d9505c1f462761b4309b1bb713d08689759ea8b899"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/61/33/9611380c2bdb1225fdef633e2a9610622310fed35ab11dac9620972ee088/platformdirs-4.5.0.tar.gz"
    sha256 "70ddccdd7c99fc5942e9fc25636a8b34d04c24b335100223152c2803e4063312"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/a4/d5/b0ccd381d55c8f45d46f77df6ae59fbc23d19e901e2d523395598e5f4c93/virtualenv-20.35.3.tar.gz"
    sha256 "4f1a845d131133bdff10590489610c98c168ff99dc75d6c96853801f7f67af44"
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
    (testpath/".config/fish/functions/fish_prompt.fish").write <<~FISH
      function fish_prompt --description 'Test prompt for virtualfish'
        echo -n -s (pwd) 'VIRTUAL_ENV=' (basename "$VIRTUAL_ENV") '>'
      end
    FISH

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
