class Zns < Formula
  desc "CLI tool for querying DNS records with readable, colored output"
  homepage "https://github.com/znscli/zns"
  url "https://github.com/znscli/zns/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "ca22ea3cdf0e46f79c64e5a7d442e4242d5d27acd6d4c031f677aabeac0c7b14"
  license "MIT"
  head "https://github.com/znscli/zns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8610f17339cf2a4b507db3de681f008e90d7b05931d5c80fc84e0c7564385e9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8610f17339cf2a4b507db3de681f008e90d7b05931d5c80fc84e0c7564385e9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8610f17339cf2a4b507db3de681f008e90d7b05931d5c80fc84e0c7564385e9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "038b4beebadb645f7bf3b89d208fb90ae191ac34e8cae2708a1dd60107137959"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1e0666fe60c823f0ae70e36ece6b0db4cc836679207e697634d64eb9167bd1b"
    sha256 cellar: :any,                 x86_64_linux:  "1c2f347241913ebc20f406d114cbaab4f020186d5dee7abea4960c2cac521825"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/znscli/zns/cmd.version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zns --version")
    assert_match "hera.ns.cloudflare.com.", shell_output("#{bin}/zns example.com -q NS --server 1.1.1.1")
  end
end
