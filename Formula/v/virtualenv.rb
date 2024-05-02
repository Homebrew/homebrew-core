class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/93/9f/97beb3dd55a764ac9776c489be4955380695e8d7a6987304e58778ac747d/virtualenv-20.26.1.tar.gz"
  sha256 "604bfdceaeece392802e6ae48e69cec49168b9c5f4a44e483963f9242eb0e78b"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "274ebe5338ab4840814322e890660ed48d66d2f41f10b9a2d60d35bedf1a5d26"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "274ebe5338ab4840814322e890660ed48d66d2f41f10b9a2d60d35bedf1a5d26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "274ebe5338ab4840814322e890660ed48d66d2f41f10b9a2d60d35bedf1a5d26"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8cb3457fe2caff20682a466aa10ed856d3b7e0d8b9f22d8abe8994413148c57"
    sha256 cellar: :any_skip_relocation, ventura:        "c8cb3457fe2caff20682a466aa10ed856d3b7e0d8b9f22d8abe8994413148c57"
    sha256 cellar: :any_skip_relocation, monterey:       "c8cb3457fe2caff20682a466aa10ed856d3b7e0d8b9f22d8abe8994413148c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f92800f613a769556ce92bcd9e5d0a5199decefde4af2e7bfd2a066bca442688"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/06/ae/f8e03746f0b62018dcf1120f5ad0a1db99e55991f2cda0cf46edc8b897ea/filelock-3.14.0.tar.gz"
    sha256 "6ea72da3be9b8c82afd3edcf99f2fffbb5076335a5ae4d03248bb5b6c3eae78a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b2/e4/2856bf61e54d7e3a03dd00d0c1b5fa86e6081e8f262eb91befbe64d20937/platformdirs-4.2.1.tar.gz"
    sha256 "031cd18d4ec63ec53e82dceaac0417d218a6863f7745dfcc9efe7793b7039bdf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
