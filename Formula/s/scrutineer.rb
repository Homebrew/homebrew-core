class Scrutineer < Formula
  desc "Security through scrutiny"
  homepage "https://github.com/alpha-omega-security/scrutineer"
  url "https://github.com/alpha-omega-security/scrutineer/archive/refs/tags/v2026.10.10.1.tar.gz"
  sha256 "ef9fa95047157272368b5ee56e8b1d59d15994ce2539002079e92727ab3cd008"
  license "MIT"
  head "https://github.com/alpha-omega-security/scrutineer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c8956ac43fdf22de735b0dd4094d2e8fdbf54c9dbd1605e24c5a69cf8aa98796"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8956ac43fdf22de735b0dd4094d2e8fdbf54c9dbd1605e24c5a69cf8aa98796"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8956ac43fdf22de735b0dd4094d2e8fdbf54c9dbd1605e24c5a69cf8aa98796"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b8f23495f488124f3427a3714486329c6c3845f7b54db75ba457d9b7cef54006"
    sha256 cellar: :any,                 x86_64_linux:      "9ced6c8653e16c189676a45e7e135d2ba9010fe680e236c6f0d58b44fb1b4ffa"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/scrutineer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrutineer version")

    output = shell_output("#{bin}/scrutineer -runtime brew 2>&1", 1)
    assert_match "runtime: must be \\\"docker\\\", \\\"podman\\\", or \\\"apple\\\"", output
  end
end
