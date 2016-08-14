class Thefuck < Formula
  include Language::Python::Virtualenv

  desc "Programatically correct mistyped console commands"
  homepage "https://github.com/nvbn/thefuck"
  url "https://files.pythonhosted.org/packages/60/79/be88fab918f5b1004174d51c3bdcdf69768d9f5d66a148c6214b1a1ddb13/thefuck-3.11.tar.gz"
  sha256 "a7a7145699b3f6a5054f9bdb2979a74f63869803eb72125325c68991ea9a966b"
  head "https://github.com/nvbn/thefuck.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "76b8b3a739db3d716d983fd30ce15c3ccb2056cc1d52fea2f15c4a9c8f8fd7ec" => :el_capitan
    sha256 "cf3be90c176ee71167389e325f0de3663a82567572fe528971733e3165ff304d" => :yosemite
    sha256 "3690744f57178d0e2e945b3039d0ce937aa774533909509d9ffc59461d69a9e8" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/f0/d0/21c6449df0ca9da74859edc40208b3a57df9aca7323118c913e58d442030/colorama-0.3.7.tar.gz"
    sha256 "e043c8d32527607223652021ff648fbb394d5e19cba9f1a698670b338c9d782b"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/13/8a/4eed41e338e8dcc13ca41c94b142d4d20c0de684ee5065523fee406ce76f/decorator-4.0.10.tar.gz"
    sha256 "9c6e98edcb33499881b86ede07d9968c81ab7c769e28e9af24075f0a5379f070"
  end

  resource "pathlib2" do
    url "https://files.pythonhosted.org/packages/c9/27/8448b10d8440c08efeff0794adf7d0ed27adb98372c70c7b38f3947d4749/pathlib2-2.1.0.tar.gz"
    sha256 "deb3a960c1d55868dfbcac98432358b92ba89d95029cddd4040db1f27405055c"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/22/a8/6ab3f0b3b74a36104785808ec874d24203c6a511ffd2732dd215cf32d689/psutil-4.3.0.tar.gz"
    sha256 "86197ae5978f216d33bfff4383d5cc0b80f079d09cf45a2a406d1abb5d0299f0"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats; <<-EOS.undent
    Add the following to your .bash_profile, .bashrc or .zshrc:

      eval "$(thefuck --alias)"

    For other shells, check https://github.com/nvbn/thefuck/wiki/Shell-aliases
    EOS
  end

  test do
    ENV["THEFUCK_REQUIRE_CONFIRMATION"] = "false"

    output = shell_output("#{bin}/thefuck --version 2>&1")
    assert_match "The Fuck #{version} using Python", output

    output = shell_output("#{bin}/thefuck --alias")
    assert_match /.+TF_ALIAS.+thefuck.+/, output

    output = shell_output("#{bin}/thefuck git branchh")
    assert_equal "git branch", output.chomp

    output = shell_output("#{bin}/thefuck echho ok")
    assert_equal "echo ok", output.chomp

    output = shell_output("#{bin}/fuck")
    assert_match "Seems like fuck alias isn't configured!", output
  end
end
