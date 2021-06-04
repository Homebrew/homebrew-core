class Ykdl < Formula
  include Language::Python::Virtualenv

  desc "Video downloader that focus on China mainland video sites"
  homepage "https://github.com/zhangn1985/ykdl"
  url "https://github.com/zhangn1985/ykdl/archive/v1.7.1.tar.gz"
  sha256 "15b4b977b9fca6f9b646d360206987618dc851a78cc49b29fda60b49f9a4d8a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "39b90419e77cc1a805a498fd4c7700a58a26391e3b67cffb9798723e33f214bb"
    sha256 cellar: :any_skip_relocation, big_sur:       "2b393c18e696763fc50d9bf4c898cc0f02930d02ca775a85226154d5f0ff5bec"
    sha256 cellar: :any_skip_relocation, catalina:      "2b393c18e696763fc50d9bf4c898cc0f02930d02ca775a85226154d5f0ff5bec"
    sha256 cellar: :any_skip_relocation, mojave:        "2b393c18e696763fc50d9bf4c898cc0f02930d02ca775a85226154d5f0ff5bec"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To merge video slides, run `brew install ffmpeg`."
  end

  test do
    system bin/"ykdl", "--info", "https://v.youku.com/v_show/id_XNTAzNDM5NTQ5Mg==.html"
  end
end
