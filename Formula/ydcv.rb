class Ydcv < Formula
  include Language::Python::Virtualenv

  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://github.com/felixonmars/ydcv/archive/0.7.tar.gz"
  sha256 "03dd5de36ea8fce3170e678e63fc3694e2718b22bc5e1526e3e07f5c36ec9aa0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c3b86d6f485f64c93716604031b7ab9981bcaae43096b545a753e114e6bd7b9" => :catalina
    sha256 "d4782bc68e0fe4fcc0d9687d44c9f4cf19188644bc723ad0de21e1c4629c757e" => :mojave
    sha256 "306a3fba391696ddf6a1031774906786421ae4df2a2466f4b05eb9c2e7c34a57" => :high_sierra
    sha256 "24bd213b43d60cf2ef49868c3419bf09bce242d82ce78c4cd4d793c01d45676c" => :sierra
  end

  depends_on "python"

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version

    zsh_completion.install "contrib/zsh_completion" => "_ydcv"
    virtualenv_install_with_resources
  end

  def caveats; <<~EOS
    You need to add a config for API Key, read more at https://github.com/felixonmars/ydcv
  EOS
  end

  test do
    system "#{bin}/ydcv", "--help"
  end
end
