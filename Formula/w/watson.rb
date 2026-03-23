class Watson < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to track (your) time"
  homepage "https://jazzband.github.io/Watson/"
  url "https://files.pythonhosted.org/packages/a9/61/868892a19ad9f7e74f9821c259702c3630138ece45bab271e876b24bb381/td-watson-2.1.0.tar.gz"
  sha256 "204384dc04653e0dbe8f833243bb833beda3d79b387fe173bfd33faecdd087c8"
  license "MIT"
  revision 10
  head "https://github.com/jazzband/Watson.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd59d5755139b4ef6952e14515584bc20dfa1603f89caee9057532b2bce7f611"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43673f64013557f7d5694db5e026908ffb66a70f617b4c6d8c026470b79bb9e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f490cf7058219e9c270dc8b5cdfd05858fff45fc58ab70628c9c44efa97e217"
    sha256 cellar: :any_skip_relocation, sonoma:        "29d16ea3e55b56995e95e4e14045bf36072147c56da7b3d2dbf1451981614ce6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "155dd0deb4d9ccfd91caf092d719dda688ea2761bac9178271b4c614aa6ae482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a28ef0742aa99dbd31a42f7cdc49a704c1ef93140b5c1c4df977d4a9fbe8c10a"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/b9/33/032cdc44182491aa708d06a68b62434140d8c50820a087fac7af37703357/arrow-1.4.0.tar.gz"
    sha256 "ed0cc050e98001b8779e84d461b0098c4ac597e88704a655582b21d116e526d7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "click-didyoumean" do
    url "https://files.pythonhosted.org/packages/30/ce/217289b77c590ea1e7c24242d9ddd6e249e52c795ff10fac2c50062c48cb/click_didyoumean-0.3.1.tar.gz"
    sha256 "4f82fdff0dbe64ef8ab2279bd6aa3f6a99c3b28c05aa09cbfc07c9d7fbb5a463"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/5e/a7/c202b344c5ca7daf398f3b8a477eeb205cf3b6f32e7ec3a6bac0629ca975/tzdata-2025.3.tar.gz"
    sha256 "de39c2ca5dc7b0344f2eba86f49d614019d29f060fc4ebc8a417896a620b56a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    # Fix to TypeError: argument of type 'NoneType' for `if 'json' in output_format:`
    # Issue ref: https://github.com/jazzband/Watson/issues/512
    inreplace "watson/cli.py", "in output_format:", "in (output_format or ''):"

    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"watson", shell_parameter_format: :click)
  end

  test do
    system bin/"watson", "start", "foo", "+bar"
    system bin/"watson", "status"
    system bin/"watson", "stop"
    system bin/"watson", "log"
  end
end
