class Virtualfish < Formula
  include Language::Python::Virtualenv

  desc "Python virtual environment manager for the fish shell"
  homepage "https://virtualfish.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/95/03/0f7b063c25c60e4221fb2a710cce05fe4686aa5dd1f6fce4bd6abd4595e4/virtualfish-2.5.8.tar.gz"
  sha256 "ea887a44399a4b2621b71f15c1d856d54a3ff3348a3292b0dfcb2d8238fe6932"
  license "MIT"
  head "https://github.com/justinmayer/virtualfish.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1982a9e8a591cfe4070142747273e43a26b672c5bf65ab9074223ee38a8c1c37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3aaccd46b0a764ff98ca2d1dd1c9d97445f2d17e09fc43b66e16c5ca34a40ff6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ef56f42f156957be695a4cc78428e6a2e20b68270639319db61d1fc99e208d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "0eaaae596d89857d5f9caed9e3e8d5da9687808e497727d65ac18f5e9f50db4f"
    sha256 cellar: :any_skip_relocation, ventura:        "11fef51dded409a042f18cba9d390388c471d52b302e9789279c15b2929bcc4e"
    sha256 cellar: :any_skip_relocation, monterey:       "423da65788601da0dba761fb026a2236b5dc08bb9f0c7c3f6ecb2c7d62b5671c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f22c3274d796eeee7d56be2db093f0b9c02b8d554818f54695795a2e3f339bc"
  end

  depends_on "fish"
  depends_on "python@3.12"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/38/ff/877f1dbe369a2b9920e2ada3c9ab81cf6fe8fa2dce45f40cad510ef2df62/filelock-3.13.4.tar.gz"
    sha256 "d13f466618bfde72bd2c18255e269f72542c6e70e7bac83a0232d6b1cc5c8cf4"
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
    url "https://files.pythonhosted.org/packages/d8/02/0737e7aca2f7df4a7e4bfcd4de73aaad3ae6465da0940b77d222b753b474/virtualenv-20.26.0.tar.gz"
    sha256 "ec25a9671a5102c8d2657f62792a27b48f016664c6873f6beed3800008577210"
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
