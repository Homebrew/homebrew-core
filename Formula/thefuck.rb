class Thefuck < Formula
  desc "Programatically correct mistyped console commands"
  homepage "https://github.com/nvbn/thefuck"
  head "https://github.com/nvbn/thefuck.git"

  stable do
    url "https://files.pythonhosted.org/packages/9d/32/a7db90523d5d2814942bb30b9002a2ef0b76e6955de94c9584cb3e303b6c/thefuck-3.10.tar.gz"
    sha256 "123358ba63b8053e78dc687215d0f703d1c346d8bd14c805487b6a3e2a7a1488"

    # Fixes "ImportError: No module named pip"
    patch do
      url "https://github.com/nvbn/thefuck/commit/965c05bf.patch"
      sha256 "398004ca224f3528f6f6584ff683ee831295d780d86c016920a7d88271431887"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "57eea367ddd6055b84916760e484f61d320191fadd1711e2b14b143f1830bbf7" => :el_capitan
    sha256 "e63986f27e4f3c5e5b2bc91b66dd92191ba33076d3957a43b6e35c29a577fca5" => :yosemite
    sha256 "074dbfe6f59f839f73305a02d4641d2fb3bd805bfcfe523c08804d91f6756cb1" => :mavericks
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

  # needs a recent setuptools
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9f/7c/0a33c528164f1b7ff8cf0684cf88c2e733c8ae0119ceca4a3955c7fc059d/setuptools-23.1.0.tar.gz"
    sha256 "4e269d36ba2313e6236f384b36eb97b3433cf99a16b94c74cca7eee2b311f2be"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[colorama decorator pathlib2 psutil setuptools six].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
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
