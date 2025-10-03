class Wgetpaste < Formula
  desc "Automate pasting to a number of pastebin services"
  homepage "https://wgetpaste.zlin.dk/"
  url "https://github.com/zlin/wgetpaste/releases/download/2.34/wgetpaste-2.34.tar.xz"
  sha256 "bd6d06ed901a3d63c9c8c57126084ff0994f09901bfb1638b87953eac1e9433f"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "19eda68054f097182aff7eefd0edd7cb34b02d1e380b74c01cc6523d5bbcd137"
  end

  depends_on "wget"

  def install
    bin.install "wgetpaste"
    zsh_completion.install "_wgetpaste"
  end

  test do
    system bin/"wgetpaste", "-S"
  end
end
