class Shuffledns < Formula
  desc "Enumerate subdomains using active bruteforce & resolve subdomains with wildcards"
  homepage "https://github.com/projectdiscovery/shuffledns"
  url "https://github.com/projectdiscovery/shuffledns/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "ce61eb210c0bb7ff5cc2e0d45e90129764494d9c0b8883e04fe67b16169ab707"
  license "GPL-3.0-or-later"
  head "https://github.com/projectdiscovery/shuffledns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4446fb577a61311cec3fe194c22e8eec950c14f386bd15546061149dde598b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4446fb577a61311cec3fe194c22e8eec950c14f386bd15546061149dde598b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4446fb577a61311cec3fe194c22e8eec950c14f386bd15546061149dde598b6"
    sha256 cellar: :any_skip_relocation, ventura:        "e102f9df27443a714f61c286a70ee69f05806197e2ba32c01cc432208dded537"
    sha256 cellar: :any_skip_relocation, monterey:       "e102f9df27443a714f61c286a70ee69f05806197e2ba32c01cc432208dded537"
    sha256 cellar: :any_skip_relocation, big_sur:        "e102f9df27443a714f61c286a70ee69f05806197e2ba32c01cc432208dded537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3618e68a2abf441d1c8f48860a91cbb12f49c0225dfe8c5882e5a1dbd778442f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/shuffledns"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuffledns -version 2>&1")
    assert_match "no resolver list provided", shell_output("#{bin}/shuffledns 2>&1", 1)
  end
end
