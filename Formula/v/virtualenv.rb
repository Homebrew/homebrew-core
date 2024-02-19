class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/94/d7/adb787076e65dc99ef057e0118e25becf80dd05233ef4c86f07aa35f6492/virtualenv-20.25.0.tar.gz"
  sha256 "bf51c0d9c7dd63ea8e44086fa1e4fb1093a31e963b86959257378aef020e1f1b"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e68b2aaff56709400a61a7d200cc76fe76440ac66922bee4a93af48315665ac0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc1655aba6bb5e5fdd4f0069751e257190c07acf3fdb4c2d7e0526b1ea42f053"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31729dbbfe52488aaa0c55a7b573d8f8f02dd3d029a6ba700373133655dc8c10"
    sha256 cellar: :any_skip_relocation, sonoma:         "4db5292d0b04d8e3df7bd49eaecab2d23e799fbc3044ae68498b17a5e4e44064"
    sha256 cellar: :any_skip_relocation, ventura:        "98fef2d216311c790bfc50f352d970a5b39e8c416f9d309d1d1781dfce7c5440"
    sha256 cellar: :any_skip_relocation, monterey:       "9cbb21969f53c6ccfac2c7863f8087bc7873bfd4c19bb05d50ea228a27557ce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "415676b3994f7baa2696a7969ffa884e586711d798134cd0a54e51114f6e6c7f"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
