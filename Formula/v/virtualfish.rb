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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6cf1777dd0185e244f54df799d2f8c123fc94485edb9d851119a8b349b863ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf5cff6492eed180889df85b0bb7a7e54b0dbad81ee435d89f94170c5a5ea485"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "769c050176581f594b65834b43cb242d3433cf42fc79be0d23793deff75ea8eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "629d169987b81c46b5f14176687eab3c137d871910ef51170c41ef55f6e9f73e"
    sha256 cellar: :any_skip_relocation, ventura:       "51c4076c4393b96bc98eef7421d1c6787a67df0cd3126e70cffffb6c33706bf9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "666161a1e19a488d4848793824ab567310ca4fb943ba107497f3ce9c4e7a44e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97d1cf122a7c4e7c0f5d7e5b2fc1518f88ced2d73cf303433f46b6a5367f3994"
  end

  depends_on "fish"
  depends_on "python@3.13"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/9d/db/3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1/filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pkgconfig" do
    url "https://files.pythonhosted.org/packages/c4/e0/e05fee8b5425db6f83237128742e7e5ef26219b687ab8f0d41ed0422125e/pkgconfig-1.5.5.tar.gz"
    sha256 "deb4163ef11f75b520d822d9505c1f462761b4309b1bb713d08689759ea8b899"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/1f/5a/07871137bb752428aa4b659f910b399ba6f291156bdea939be3e96cae7cb/psutil-6.1.1.tar.gz"
    sha256 "cf8496728c18f2d0b45198f06895be52f36611711746b7f30c464b422b50e2f5"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/50/39/689abee4adc85aad2af8174bb195a819d0be064bf55fcc73b49d2b28ae77/virtualenv-20.28.1.tar.gz"
    sha256 "5d34ab240fdb5d21549b76f9e8ff3af28252f5499fb6d6f031adac4e5a8c5329"
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
