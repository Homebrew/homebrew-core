class Ykdl < Formula
  include Language::Python::Virtualenv

  desc "Video downloader that focus on China mainland video sites"
  homepage "https://github.com/SeaHOH/ykdl"
  url "https://files.pythonhosted.org/packages/1e/a2/8d68c0f5bfda82033fac0d36875c185241de37e1ac56f8b3f161e825a1e6/ykdl-1.8.1.post1.tar.gz"
  sha256 "97b179ef7059685fbbb24d4f50ae6e5e01f08e9c0998b292dc1ca44c1af09dc1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d289432a1f82ac4cee1805a8d07ae0e602b0395aeec2271da98580b68f5db05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "012f9a4e13373e5555c9f6f42cfe0fd56f33b3b392048a269d5ad4d132110149"
    sha256 cellar: :any_skip_relocation, monterey:       "8b2e402459b9279b606582f80ffb1718897437d60656879b7fae10b989cc04b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "abddefdc8cf1eed4a9c704569b779f22c11d095fcce7fff7b68764499853ae4a"
    sha256 cellar: :any_skip_relocation, catalina:       "d53679b31d85898eacfac4869b40ff7f1e78464cf32781ff723fb78c7a335baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f79b2d4c2c34e2a822ed8e9f98dab4ec5a0b70d8c8bd03c24de845e500850d25"
  end

  depends_on "python@3.10"

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/28/97/d2d3d96952c77e7593e0f4a634656fb384f7282327f7fef74b726b3b4c1c/iso8601-1.0.2.tar.gz"
    sha256 "27f503220e6845d9db954fb212b95b0362d8b7e6c1b2326a87061c3de93594b1"
  end

  resource "jsengine" do
    url "https://files.pythonhosted.org/packages/1c/1c/899994765c0395caec18b3e5381e61bac256c35a43f80fb468f3de689f95/jsengine-1.0.5.tar.gz"
    sha256 "f9676bad44904483f0b17bf2838b07893c9fbaf575f2153e46735b767243199f"
  end

  resource "m3u8" do
    url "https://files.pythonhosted.org/packages/0a/c1/ea98c5f109be04a745d01437f77b801192f3cf56cb834fa5e660f0a0ce03/m3u8-2.0.0.tar.gz"
    sha256 "bd8727a74c23fd706f2dc2a53f319391589ea64bb3a5c76b1c9b5707d8f4a0b0"
  end

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
