class Silitop < Formula
  include Language::Python::Virtualenv

  desc "Perf monitoring CLI tool for Apple Silicon"
  homepage "https://github.com/binlecode/silitop"
  url "https://github.com/binlecode/silitop/archive/refs/tags/v0.0.24.tar.gz"
  sha256 "52774ba2d673646617e270ee2a628c1ce2d44d0b3669fd7fd55a33408c039db6"
  license "MIT"

  depends_on arch: :arm64
  depends_on :macos
  depends_on "python@3.14"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/dd/19/e926a0dbbf93c7aeb15d4dfff0d0e3de02653b3ba540b687307d0819c1ff/blessed-1.30.0.tar.gz"
    sha256 "4d547019d7b40fc5420ea2ba2bc180fdccc31d6715298e2b49ffa7b020d44667"
  end

  resource "dashing" do
    url "https://files.pythonhosted.org/packages/bd/01/1c966934ab5ebe5a8fa3012c5de32bfa86916dba0428bdc6cdfe9489f768/dashing-0.1.0.tar.gz"
    sha256 "2514608e0f29a775dbd1b1111561219ce83d53cfa4baa2fe4101fab84fd56f1b"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/35/a2/8e3becb46433538a38726c948d3399905a4c7cabd0df578ede5dc51f0ec2/wcwidth-0.6.0.tar.gz"
    sha256 "cdc4e4262d6ef9a1a57e018384cbeb1208d8abbc64176027e2c2455c81313159"
  end

  def install
    virtualenv_install_with_resources
    mv bin/"asitop", bin/"silitop"
    bin.env_script_all_files(libexec, PYTHONDONTWRITEBYTECODE: "1")
  end

  test do
    assert_match "Performance monitoring CLI tool", shell_output("#{bin}/silitop --help")
  end
end
