class Ydcv < Formula
  include Language::Python::Virtualenv

  desc "YouDao Console Version"
  homepage "https://github.com/felixonmars/ydcv"
  url "https://github.com/felixonmars/ydcv/archive/0.7.tar.gz"
  sha256 "03dd5de36ea8fce3170e678e63fc3694e2718b22bc5e1526e3e07f5c36ec9aa0"
  license "GPL-3.0"
  revision 3

  bottle do
    cellar :any_skip_relocation
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
