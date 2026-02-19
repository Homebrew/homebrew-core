class Wakadash < Formula
  desc "Live terminal dashboard for WakaTime coding stats"
  homepage "https://github.com/b00y0h/wakadash"
  url "https://github.com/b00y0h/wakadash/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "8cd2bfef0fc8399fb1b1e34557b0a83afecf53c2a907fa8e349f3ca3298988e4"
  license "MIT"

  depends_on "go" => :build

  def install
    # Set ldflags for version injection (matches GoReleaser pattern)
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    # Build from source using Go toolchain
    system "go", "build", *std_go_args(ldflags:), "./cmd/wakadash"
  end

  test do
    # Test version output
    assert_match version.to_s, shell_output("#{bin}/wakadash --version")

    # Test graceful failure when ~/.wakatime.cfg doesn't exist
    # (Don't test actual dashboard since that requires WakaTime API key)
    output = shell_output("#{bin}/wakadash 2>&1", 1)
    assert_match(/wakatime|config|api/i, output)
  end
end
