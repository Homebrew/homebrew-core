class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift/releases/download/v5.4.0/rswift-v5.4.0-source.tar.gz"
  sha256 "5153e7d122412ced4f04b6fc92c10dad0a861900858543a77ce1bf11850d4184"
  license "MIT"
  head "https://github.com/mac-cain13/R.swift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2eb8a16c1ea824ce6ea93423f083cd94e1fbe90ca3cb9daedc985347b101f657"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b07728bea1baa0568381b1f41a34d66bbc283e7a1c5813e7078faf30a1c6a102"
    sha256 cellar: :any_skip_relocation, monterey:       "beb6182193ec3a444d4c4661ec9b5dc2fddbb8fe398945f2d5bbb8a63f773492"
    sha256 cellar: :any_skip_relocation, big_sur:        "495500a61dc7f30d7f00f19a1c427a43990c1beb8cf99bee2b50c373c7d7eab7"
    sha256 cellar: :any_skip_relocation, catalina:       "4776447ac9845ebd27c5ac2ab8bec3c50e79c8c7105e8702f67393da5a609747"
    sha256 cellar: :any_skip_relocation, mojave:         "8c46754db5932ecefafee7b4fb665a8697fe72dadf86c6262458946e64e4265c"
  end

  depends_on xcode: "10.2"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
    assert_match "[R.swift] Failed to write out", shell_output("#{bin}/rswift generate #{testpath} 2>1&")
  end
end
