class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.74.1.tar.gz"
  sha256 "7658468701fc71d9544e43b5cee8c9a55fc3febef29830003768f0b849868e98"
  license "AGPL-3.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b193e1914759231a1a0ecfda75bcecec5b78df133ba66bb539cff424cf3ad1ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84d801a2d23a8b3dd8dce53734516b70a63d37eb8b94e51848e8eab1a55c63e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f23909cd70d440f16b0941eb605070dffabd7a0d0a3008840858ca3824ffd0b"
    sha256 cellar: :any_skip_relocation, ventura:        "2496ec5d1e722ce4fe8179504d5977c67a3eb6e8e10df30a14b7f413bfc728c7"
    sha256 cellar: :any_skip_relocation, monterey:       "8525fb8851ab311a92492e7cb1a5cdc158df98218d8f750dde95f89eef7520df"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf6dfde90978706cff32bf0cc03dcba0621029a39a0aa3f44a9f34411afd14d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8e2d7794e4f93013f7b1cc0e36570b9121c19c5e57acd5a84df3ba44f37b74a"
  end

  # Support for go 1.20 is merged upstream but not yet landed in a tag:
  # https://github.com/storj/storj/commit/873a2025307ef85a1ff2f6bab37513ce3a0e0b4c
  # Remove on next release.
  depends_on "go@1.19" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~EOS
      [metrics]
      addr=
    EOS
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
