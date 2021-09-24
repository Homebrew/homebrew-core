class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/dd/40/9bc1b32521f78c293c1f8ca423c725737dfa9d09640dbeec61cebca7c5f2/virtualenv-20.8.1.tar.gz"
  sha256 "bcc17f0b3a29670dd777d6f0755a4c04f28815395bca279cdcb213b97199a6b8"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "40127b72306e8b72b152143c19c79648b91107feba2ad4b3a45d794fd9e23829"
    sha256 cellar: :any_skip_relocation, big_sur:       "9674b080a12f4f69e15b7c618331a06fc2821c538092f21985455cb18a53355c"
    sha256 cellar: :any_skip_relocation, catalina:      "494d45602e726b17f8f8c457d4e87838c667a57d23601854751f18ddb4285254"
    sha256 cellar: :any_skip_relocation, mojave:        "55a8fdc1b2c16eb93c6c4eeb06b4ef0f4b326c2ef9e4cb1483cb49da07602992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddbe88987ed91f26b392cd52c59a84225f23033dae12878289664efeb5cd17da"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "backports.entry-points-selectable" do
    url "https://files.pythonhosted.org/packages/e4/7e/249120b1ba54c70cf988a8eb8069af1a31fd29d42e3e05b9236a34533533/backports.entry_points_selectable-1.1.0.tar.gz"
    sha256 "988468260ec1c196dab6ae1149260e2f5472c9110334e5d51adcb77867361f6a"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/56/ed/9c876a62efda9901863e2cc8825a13a7fcbda75b4b498103a4286ab1653b/distlib-0.3.3.zip"
    sha256 "d982d0751ff6eaaab5e2ec8e691d949ee80eddf01a62eaa96ddb11531fe16b05"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/14/ec/6ee2168387ce0154632f856d5cc5592328e9cf93127c5c9aeca92c8c16cb/filelock-3.0.12.tar.gz"
    sha256 "18d82244ee114f543149c66a6e0c14e9c4f8a1044b5cdaadd0f82159d6a6ff59"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/e2/d4/c6ffe89de09851892b1418dc22f6ab019b7b6f362532ab813c262e1722bb/platformdirs-2.3.0.tar.gz"
    sha256 "15b056538719b1c94bdaccb29e5f81879c7f7f0f4a153f46086d155dffcd4f0f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
