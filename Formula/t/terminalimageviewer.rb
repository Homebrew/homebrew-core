class Terminalimageviewer < Formula
  desc "Display images in a terminal using block graphic characters"
  homepage "https://github.com/stefanhaustein/TerminalImageViewer"
  url "https://github.com/stefanhaustein/TerminalImageViewer/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "08d0c30e3ffa47b69d1bce07bea56f04b7deb4a8a79307ce435a4f0852fbcd5f"
  license "Apache-2.0"
  head "https://github.com/stefanhaustein/TerminalImageViewer.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d15318b665e2ca76d7d9f1c2c7f6d6fddef75446202fbd6dc7444a97c14b58d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6ee22b5d19739497f5fd9a9e082da1106cca1ebe64d1307ddb436ba7c435671a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b97f5e9862b3628ec382a93bea224821d85b770dc7e6024c434148993a48a6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7def3c517971218e5878b610d27c01dae72e0ee14716063d243ad58248e3ac43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8050c890cdf88c6a0b1b5a9e70497c7810b1af57463d4213c0369fd397ff9c71"
    sha256 cellar: :any_skip_relocation, sonoma:         "d518d4e732fe89892e30ce4f3566803575ffc8cb79c09483a2780862704f8b81"
    sha256 cellar: :any_skip_relocation, ventura:        "48dbddfc5411ffb659e84592e7d4c7da6e9384eb14567d8fa3727fdff25f39c9"
    sha256 cellar: :any_skip_relocation, monterey:       "24fcc2c2d18fabd9f35449bc9fd08b4c2d5bedd17a3905ada74cf50858064c34"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5a6596ac570f7ce8eb5789f7521dbae729fe2f9f319fc73c983ac664130b2fa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09bed7a395fb96ff84f0bf05ed864786956f90048e25c4c918cdf68055b88fbe"
  end

  depends_on "imagemagick"

  def install
    cd "src" do
      system "make"
      bin.install "tiv"
    end
  end

  test do
    system bin/"tiv", test_fixtures("test.png")
  end
end
