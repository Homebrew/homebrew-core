class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "8aa3ce8ddb9f2ef06b78856a9a6ca44842bd842e8b7d0b412dee8cb76f6cb665"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19ec3db0f61fc1094357b4882b3badfc6c9ce8f88c1788d201e994244cc07663"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19ec3db0f61fc1094357b4882b3badfc6c9ce8f88c1788d201e994244cc07663"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19ec3db0f61fc1094357b4882b3badfc6c9ce8f88c1788d201e994244cc07663"
    sha256 cellar: :any_skip_relocation, sonoma:        "aab2c2b9236464179296e81a007b915b5d73e8a0a975b6ecd3e72612a5942779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8bf2d8bcdc82b1157d5e3f53f06e34b3fb25f73b42a8d2cd3a26742b105a0f6"
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
