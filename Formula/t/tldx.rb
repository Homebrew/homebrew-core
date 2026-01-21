class Tldx < Formula
  desc "Domain Availability Research Tool"
  homepage "https://brandonyoung.dev/blog/introducing-tldx/"
  url "https://github.com/brandonyoungdev/tldx/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "e331e89c3d39c79d6efc4b3567f2c134da29761e58621239a54bab3423fea575"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c9d62b0c89a31f5a17ac6f6ce36c7c74fce59eb5e3819d6f792eaf768e3d826"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c9d62b0c89a31f5a17ac6f6ce36c7c74fce59eb5e3819d6f792eaf768e3d826"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c9d62b0c89a31f5a17ac6f6ce36c7c74fce59eb5e3819d6f792eaf768e3d826"
    sha256 cellar: :any_skip_relocation, sonoma:        "c42432ee30a7319e322d1ebb760961dee55f35e8257f9ba5bc483eff8f1c2361"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e17c2a89ba7251add592ea67332c33c4d1e786ba46ec90a8551aa3a0584c48d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2790ada80cef3c9b7b3d04c5d6395f4de6cb85233e340510dcc058f5ae4faeb8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/brandonyoungdev/tldx/cmd.Version=#{version}")
  end

  test do
    assert_match "brew.sh is not available", shell_output("#{bin}/tldx brew --tlds sh")

    assert_match version.to_s, shell_output("#{bin}/tldx --version")
  end
end
