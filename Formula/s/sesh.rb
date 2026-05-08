class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.26.1.tar.gz"
  sha256 "06fbffad2c496012ea21d9cc8d556402b60b92d260a3bda4f4cb29ec8faf574f"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed1ac024eea59d24c102131bf2fa587ae5c702ab87cc377e67071b3e15715021"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed1ac024eea59d24c102131bf2fa587ae5c702ab87cc377e67071b3e15715021"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed1ac024eea59d24c102131bf2fa587ae5c702ab87cc377e67071b3e15715021"
    sha256 cellar: :any_skip_relocation, sonoma:        "64ba4c1abdd60ca1131fbc486284695a18892cda34ce3d9a94e641f3d592dd7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09c54df0c017c65eaa2dcea5dfe4dcc89b196ae21245fb09d8b697745288f193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75bd14b0df3b00841766566cea6fc7400428dc6080e8a7ce2a59d7ddd0c301c2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"sesh", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end
