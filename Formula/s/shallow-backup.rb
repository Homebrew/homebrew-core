class ShallowBackup < Formula
  include Language::Python::Virtualenv

  desc "Git-integrated backup tool for macOS and Linux devs"
  homepage "https://github.com/alichtman/shallow-backup"
  url "https://files.pythonhosted.org/packages/18/70/15a97aee274d59896c4224b216cd6cd843c9cfd62153788b93a0016681db/shallow-backup-6.2.tar.gz"
  sha256 "bb732fa1dee15a1ac27dc9621c4f1f8d1c70f3b88d10b99224ea49106f26e58b"
  license "MIT"
  revision 1
  head "https://github.com/alichtman/shallow-backup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a6a6639d95d70b1e4de8f28ba91752df01e0ac86e21e341585b843b1d7a1a09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "009c2d332a99014ca3740f5b17ff5957f7a5a0d5dac821b35f54004f1e88146f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0709fd2ea3dc6f256c48408be391715a51a7f85c7620c3f3cb3eed5b1bb1e49"
    sha256 cellar: :any_skip_relocation, sonoma:         "a646322b741a3ff0cc7becc067b9e8afe257d8770fd2897c15e53fe0e8e935d6"
    sha256 cellar: :any_skip_relocation, ventura:        "3783244c76113f1eaf30c3fa01a820dbb5972d0ac6fc2ba589a4c45e773b85c3"
    sha256 cellar: :any_skip_relocation, monterey:       "f2198a7e2056234a1e2de2c94337113892d51aea1a3c0d2916f8e8e9cbb06882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8cf43c44ad13c3697afc1dd9140fa7b17196c6948e5ceab8fcde4d84f21cf36"
  end

  depends_on "python-click"
  depends_on "python@3.12"
  depends_on "six"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/25/ae/92e9968ad23205389ec6bd82e2d4fca3817f1cdef34e10aa8d529ef8b1d7/blessed-1.20.0.tar.gz"
    sha256 "2cdd67f8746e048f00df47a2880f4d6acbcdb399031b604e34ba8f71d5787680"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "editor" do
    url "https://files.pythonhosted.org/packages/65/f7/286f79cc04f0ea0f52b9f7685200a2defd66803656876ef35459a5960f45/editor-1.6.5.tar.gz"
    sha256 "5a8ad611d2a05de34994df3781605e26e63492f82f04c2e93abdd330eed6fa8d"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/19/0d/bbb5b5ee188dec84647a4664f3e11b06ade2bde568dbd489d9d64adef8ed/gitdb-4.0.11.tar.gz"
    sha256 "bf5421126136d6d0af55bc1e7c1af1c397a34f5b7bd79e776cd3e89785c2b04b"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/e5/c2/6e3a26945a7ff7cf2854b8825026cf3f22ac8e18285bc11b6b1ceeb8dc3f/GitPython-3.1.41.tar.gz"
    sha256 "ed66e624884f76df22c8e16066d567aaa5a37d5b5fa19db2c6df6f7156db9048"
  end

  resource "inquirer" do
    url "https://files.pythonhosted.org/packages/87/7a/acbfd27542c5d87d1ee025cd54a7d9923f57d0a89d8d16f526a622237981/inquirer-3.2.1.tar.gz"
    sha256 "d5ff9bb8cd07bd3f076eabad8ae338280886e93998ff10461975b768e3854fbc"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/a1/57/439aaa28659e66265518232bf4291ae5568aa01cd9e0e0f6f8fe3b300e9e/readchar-4.0.5.tar.gz"
    sha256 "08a456c2d7c1888cde3f4688b542621b676eb38cd6cfed7eb6cb2e2905ddc826"
  end

  resource "runs" do
    url "https://files.pythonhosted.org/packages/8b/91/4d1e3f01cecdd7f8a5486f6a5961bf2cd1d48b98b48541b08e783e3c8853/runs-1.2.0.tar.gz"
    sha256 "8804271011b7a2eeb0d77c3e3f556e5ce5f602fa0dd2a31ed0c1222893be69b7"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/fc/c9/b146ca195403e0182a374e0ea4dbc69136bad3cd55bc293df496d625d0f7/setuptools-69.0.3.tar.gz"
    sha256 "be1af57fc409f93647f2e8e4573a142ed38724b8cdd389706a867bb4efcf1e78"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/88/04/b5bf6d21dc4041000ccba7eb17dd3055feb237e7ffc2c20d3fae3af62baa/smmap-5.0.1.tar.gz"
    sha256 "dceeb6c0028fdb6734471eb07c0cd2aae706ccaecab45965ee83f11c8d3b1f62"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "xmod" do
    url "https://files.pythonhosted.org/packages/72/b2/e3edc608823348e628a919e1d7129e641997afadd946febdd704aecc5881/xmod-1.8.1.tar.gz"
    sha256 "38c76486b9d672c546d57d8035df0beb7f4a9b088bc3fb2de5431ae821444377"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(
      bin/"shallow-backup",
      shells:                 [:fish, :zsh],
      shell_parameter_format: :click,
    )
  end

  test do
    # Creates a config file and adds a test file to it
    # There is colour in stdout, hence there are ANSI escape codes
    assert_equal "\e[34m\e[1mCreating config file at: \e[22m#{pwd}/.config/shallow-backup.conf\e[0m\n" \
                 "\e[34m\e[1mAdded: \e[22m#{test_fixtures("test.svg")}\e[0m",
    shell_output("#{bin}/shallow-backup --add-dot #{test_fixtures("test.svg")}").strip

    # Checks if config file was created
    assert_predicate testpath/".config/shallow-backup.conf", :exist?

    # Checks if the test file is in the config
    assert_match "test.svg", shell_output("#{bin}/shallow-backup --show")
  end
end
