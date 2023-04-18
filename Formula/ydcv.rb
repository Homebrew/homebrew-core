class Ydcv < Formula
  include Language::Python::Virtualenv

  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://files.pythonhosted.org/packages/1f/29/17124ebfdea8d810774977474a8652018c04c4a6db1ca413189f7e5b9d52/ydcv-0.7.tar.gz"
  sha256 "53cd59501557496512470e7db5fb14e42ddcb411fe4fa45c00864d919393c1da"
  license "GPL-3.0"
  revision 4
  head "https://github.com/felixonmars/ydcv.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb6154d76b16bd58ccd709104fedad005bb7987624b81947dcb56e89e85f7c73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb6154d76b16bd58ccd709104fedad005bb7987624b81947dcb56e89e85f7c73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb6154d76b16bd58ccd709104fedad005bb7987624b81947dcb56e89e85f7c73"
    sha256 cellar: :any_skip_relocation, ventura:        "1395cd029c7edc09b2d1d12707585e41f433dd14b54bdc92dcd53376cca76570"
    sha256 cellar: :any_skip_relocation, monterey:       "1395cd029c7edc09b2d1d12707585e41f433dd14b54bdc92dcd53376cca76570"
    sha256 cellar: :any_skip_relocation, big_sur:        "1395cd029c7edc09b2d1d12707585e41f433dd14b54bdc92dcd53376cca76570"
    sha256 cellar: :any_skip_relocation, catalina:       "1395cd029c7edc09b2d1d12707585e41f433dd14b54bdc92dcd53376cca76570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52f466e847bf7841d0108b5bdb3e034ea2412d9d8d354088d270c088e784482e"
  end

  depends_on "python@3.11"

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version

    zsh_completion.install "contrib/zsh_completion" => "_ydcv"
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      You need to add a config for API Key, read more at https://github.com/felixonmars/ydcv
    EOS
  end

  test do
    system "#{bin}/ydcv", "--help"
  end
end
