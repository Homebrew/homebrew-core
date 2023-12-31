class Virtualenvwrapper < Formula
  include Language::Python::Virtualenv

  desc "Python virtualenv extensions"
  homepage "https://virtualenvwrapper.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/b3/db/450a94145125297929aca586595a8765db0ef15ca219cd47df0337480730/virtualenvwrapper-6.0.0.tar.gz"
  sha256 "4cdaca4a01bb11c3343b01439cf2d76ebe97bb28c4b9a653a9b1f1f7585cd097"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "27aadf086bfd32d04072a0ce9fc7aafa8bb9bb2da88f85e1e0525f3acabf5395"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f964a5ba544fbe850c3736d4db2e3a7fa0c56103b310df3fe71ed7155403e45b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7136734605a30830204d1c2c964918f9d12584665c16210a4df1b174e1a38d08"
    sha256 cellar: :any_skip_relocation, sonoma:         "a37eca444fc43044811aa27a5954f39decef9d3377c52523520e47e86fb47846"
    sha256 cellar: :any_skip_relocation, ventura:        "3e3bab812fff8871e56216d57587601d2e076898e891fba4cd45f01661343a2f"
    sha256 cellar: :any_skip_relocation, monterey:       "1596440e00d2b522f274e66c5521697fe8d426fcb7a583d2fc13ca44b0cdfb91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c213c60e066a3b65081c49f4583d984a39ebd678817988ea4785a476af8b0822"
  end

  depends_on "python@3.12"
  depends_on "virtualenv"

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/ac/d6/77387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780/stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
  end

  resource "virtualenv-clone" do
    url "https://files.pythonhosted.org/packages/85/76/49120db3bb8de4073ac199a08dc7f11255af8968e1e14038aee95043fafa/virtualenv-clone-0.5.7.tar.gz"
    sha256 "418ee935c36152f8f153c79824bb93eaf6f0f7984bae31d3f48f350b9183501a"
  end

  def install
    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install_symlink libexec/"bin/virtualenvwrapper_lazy.sh"
    (bin/"virtualenvwrapper.sh").write <<~SH
      #!/bin/sh
      export VIRTUALENVWRAPPER_PYTHON="#{libexec}/bin/#{python3}"
      source "#{libexec}/bin/virtualenvwrapper.sh"
    SH
  end

  def caveats
    <<~EOS
      To activate virtualenvwrapper, add the following to your shell profile
      e.g. ~/.profile or ~/.zshrc
        source virtualenvwrapper.sh
    EOS
  end

  test do
    assert_match "created virtual environment",
                 shell_output("bash -c 'source virtualenvwrapper.sh; mktmpenv'")
  end
end
