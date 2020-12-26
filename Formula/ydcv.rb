class Ydcv < Formula
  include Language::Python::Virtualenv

  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://files.pythonhosted.org/packages/1f/29/17124ebfdea8d810774977474a8652018c04c4a6db1ca413189f7e5b9d52/ydcv-0.7.tar.gz"
  sha256 "53cd59501557496512470e7db5fb14e42ddcb411fe4fa45c00864d919393c1da"
  license "GPL-3.0"
  revision 3
  head "https://github.com/felixonmars/ydcv.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c4ff545cddb41fe2ccaf575cb4f3e76c5c01f232c625eb1c530e47d2ef8075c9" => :big_sur
    sha256 "9dfe59e1a5399e705fe78e7faf28d48f970ed0790abd6beb7b67b8cafde23ac3" => :arm64_big_sur
    sha256 "a16a37a02c2a91cb46238a89d8771af6c65b623f361648e7f13247f0af9ef436" => :catalina
    sha256 "2ad28560612e25690f859e8ba31e4d7a7b35820dc414c0778aa8c99f90737ceb" => :mojave
    sha256 "148d1c3f69a30f2f7e42e037bd2dd0a704a400b41990317513d36a993f914a66" => :high_sierra
  end

  depends_on "python@3.9"

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
