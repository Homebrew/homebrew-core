class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.24.2.tar.gz"
  sha256 "dd19e3818ef7c77e36cd0bbf8de60c26183e91e838ae3025e759d36006000013"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fbbe8f4739d5828b91e12d74d4850962200622e587b7bf6174cc783682ae465"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fbbe8f4739d5828b91e12d74d4850962200622e587b7bf6174cc783682ae465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fbbe8f4739d5828b91e12d74d4850962200622e587b7bf6174cc783682ae465"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f3cea788214c8991140183f4889e6ce9182e2055c5273f1a5a6ba5b4297e765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c6cdee52beb52ff575949a790b91f1b65943d764ceeeecb6771d7da0225bdaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9eaa1162b55d0353200ce358110a4b2e523fe922cb365cdcc1483a7b86a3d1d"
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
