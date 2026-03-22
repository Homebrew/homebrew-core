class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.24.2.tar.gz"
  sha256 "dd19e3818ef7c77e36cd0bbf8de60c26183e91e838ae3025e759d36006000013"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec544c16f286645eb88aa7283839b411839c2803009b72cdd18866b2942144f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec544c16f286645eb88aa7283839b411839c2803009b72cdd18866b2942144f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec544c16f286645eb88aa7283839b411839c2803009b72cdd18866b2942144f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "eca2f930719ddb074ae426852d6211c18b978ac3b71babe303dbd7d529ff04fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74581e4dc4114455bb9dd2ba4bb20f0e2823af4eedb61b7e9bc41d52db142c41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bfc542af6cf0fa43d24b268e2b1c32bc1791b0cef8c17ef0addd6b0e4907e7d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end
