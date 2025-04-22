class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "14d69448c689ba5116a55260518ca8b6a4f659c2e41833dc1341801b0dc5ad2d"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68da55e239a522e3c8b4311407184a2bd958b83bfe7f1d64048884badf38ffd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68da55e239a522e3c8b4311407184a2bd958b83bfe7f1d64048884badf38ffd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68da55e239a522e3c8b4311407184a2bd958b83bfe7f1d64048884badf38ffd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "13f517c70687613ace023e9ad13b4dcb800f7bd3092d42e460381a6e2370685a"
    sha256 cellar: :any_skip_relocation, ventura:       "13f517c70687613ace023e9ad13b4dcb800f7bd3092d42e460381a6e2370685a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13efb4aa7dbf4b5839b25ecd7000d64a5413c5bc4348c2536e837cbb70ca8b5d"
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
