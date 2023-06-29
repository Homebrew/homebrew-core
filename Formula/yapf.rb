class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/e0/7a/9020bfa17d294b5d0d8bf26bb175ad4c90d1e3ad4039001f621ef046cb06/yapf-0.40.1.tar.gz"
  sha256 "958587eb5c8ec6c860119a9c25d02addf30a44f75aa152a4220d30e56a98037c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80bba73a25b7c33436b8b4d2cd807b05a45de6290f74ac562577c0304451f2e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30ff81bd6bc8d793242886ec13d025b1ab941bf92f6dd6cb7fc0e39643107108"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75a0982a9845c4a81f5e49570da98be6582e873db542a93a5b920acdf1af1c50"
    sha256 cellar: :any_skip_relocation, ventura:        "c8bad7425f63d9b777a998250d915c164dff024d7e97af3a46477e42d82dd044"
    sha256 cellar: :any_skip_relocation, monterey:       "a350dc2c0ff2519996bc8f5d6f04668dcb771d5dafe3726029967cbac3997e72"
    sha256 cellar: :any_skip_relocation, big_sur:        "e32bed37cb71e4aea5e8da2274e5598573d7b241794ae788fe2b08139c3ee14b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a7d59dc90febc7fd4f1db1aa07d9336f628776520cbab88dad0bec55dfd7f8b"
  end

  depends_on "python@3.11"

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a3/82/f6e29c8d5c098b6be61460371c2c5591f4a335923639edec43b3830650a4/importlib_metadata-6.7.0.tar.gz"
    sha256 "1aaf550d4f73e5d6783e7acb77aec43d49da8017410afae93822cc9cca98c4d4"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/05/31/793923615e85deef0c25abf5d044b3f99f1348b620122ab184b7d3f70f21/platformdirs-3.6.0.tar.gz"
    sha256 "57e28820ca8094678b807ff529196506d7a21e17156cb1cddb3e74cebce54640"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/yapf", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
