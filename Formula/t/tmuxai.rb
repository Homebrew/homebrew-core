class Tmuxai < Formula
  desc "AI-powered, non-intrusive terminal assistant"
  homepage "https://tmuxai.dev/"
  url "https://github.com/BoringDystopiaDevelopment/tmuxai/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "d96418e9738bdc90c60f1bda7e8c88f1dbd06a448cdcf1b26a51ad8659ddc473"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0227d5547d2bc286139172086ba8f89ca236b6d8d6505a565194e887348dde35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0227d5547d2bc286139172086ba8f89ca236b6d8d6505a565194e887348dde35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0227d5547d2bc286139172086ba8f89ca236b6d8d6505a565194e887348dde35"
    sha256 cellar: :any_skip_relocation, sonoma:        "3dd1cb67c1ace942a00db51f678ea02eaf2801e60d02f81efeb81062154b5c12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29ea784cc3f5fd705ed572ecaa911d3b6392df04e444e440d56e59f557487bd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae2e35bc64a732373a05878e0855381cebb5b8f52fb57016185f698b01e007e7"
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ldflags = "-s -w -X github.com/alvinunreal/tmuxai/internal.Version=v#{version}"

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxai -v")

    output = shell_output("#{bin}/tmuxai -f nonexistent 2>&1", 1)
    assert_match "Error reading task file", output
  end
end
