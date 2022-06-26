class Terminalimageviewer < Formula
  desc "Display images in a terminal using block graphic characters"
  homepage "https://github.com/stefanhaustein/TerminalImageViewer"
  url "https://github.com/stefanhaustein/TerminalImageViewer/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "9a5f5c8688ef8db0e88dfcea6a1ae30da32268a7ab7972ff0de71955a75af0db"
  license "Apache-2.0"
  head "https://github.com/stefanhaustein/TerminalImageViewer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbf2316ed0c4cc099c29b52dcf1970d78a90c3325ae89e3dff2e66c4faf1722d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9d5d315e5ac576411e6bc71adc39566f1610d355b4d2f243568ee44b79228e7"
    sha256 cellar: :any_skip_relocation, monterey:       "f9939913e227575dcadd570ffce7325f338de0b32381a13a57548dc81874639f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d37173ffc79b0f4e7bef0d9f24105209ddf1ea9c7283e6607b0b7549ecadcd6e"
    sha256 cellar: :any_skip_relocation, catalina:       "b0a77c46278852529506b8a6e4b0a377445005fa4ab32b003c12f0b87bddd01d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a612b37b5f01ee66ea80005c2a3d9dadbb5717512dcb890927ad1cba14e55db5"
  end

  depends_on "imagemagick"
  depends_on macos: :catalina

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    cd "src/main/cpp" do
      system "make"
      bin.install "tiv"
    end
  end

  test do
    assert_equal "\e[48;2;0;0;255m\e[38;2;0;0;255m  \e[0m",
                 shell_output("#{bin}/tiv #{test_fixtures("test.png")}").strip
  end
end
