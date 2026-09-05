class Rtk < Formula
  desc "CLI proxy to minimize LLM token consumption"
  homepage "https://www.rtk-ai.app/"
  url "https://github.com/rtk-ai/rtk/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "9a29dcc73beebacac47811b15d79f5dee9a4c4414e60623a83975867d4f68be2"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/rtk.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90061245198302451a726cd2aa0fd20e832247b8ac1693562d4dda8f97bdd4da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3a8f82ad05837dbefaaa4729c71ab10a233bd7239657aecf7c16b0746efa642"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "291530d7e6e202e2b97b7dc2963692d085bcb0af779b67a589f0bbb162154437"
    sha256 cellar: :any,                 arm64_linux:   "cd39c4ff731d9472d631ff92bb4780b95857a233505a14d41e3a74dc6a92128d"
    sha256 cellar: :any,                 x86_64_linux:  "ce3340f398900972ee8d912fb3b7364d4c5d5ec1caf57b5d9793a0d72dbfdb32"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rtk --version")

    (testpath/"homebrew.txt").write "hello from homebrew\n"
    output = shell_output("#{bin}/rtk ls #{testpath}")
    assert_match "homebrew.txt", output
  end
end
