class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.166.3.tar.gz"
  sha256 "f430a27aced2322ee5ddc74b096abae288ba30eab2fad8920ab297b848737085"
  license "AGPL-3.0-only"

  # Upstream creates stable releases and marks them as "pre-release" before
  # release (though some versions have permanently remained as "pre-release"),
  # so it's necessary to check releases. However, upstream has not marked
  # recent releases as "latest", so it's necessary to check all releases.
  # NOTE: We should return to using the `GithubLatest` strategy if/when
  # upstream reliably marks stable releases as "latest" again.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0f882e6afd1841c17a1f02bee08770e65f9741ac06c78f25c40cac0a025c7f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0f882e6afd1841c17a1f02bee08770e65f9741ac06c78f25c40cac0a025c7f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f0f882e6afd1841c17a1f02bee08770e65f9741ac06c78f25c40cac0a025c7f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fad57d6cb5c81ae4a78448c67d54982f6d44fc90c6efdba3de7c42d55a5a3337"
    sha256 cellar: :any,                 x86_64_linux:      "ad32d890f6474fc934f85e69e6876388bc2d653bbdb4d592ffc75afef45eca02"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"uplink"), "./cmd/uplink"
  end

  test do
    (testpath/"config.ini").write <<~INI
      [metrics]
      addr=
    INI
    ENV["UPLINK_CONFIG_DIR"] = testpath.to_s
    ENV["UPLINK_INTERACTIVE"] = "false"
    assert_match "No accesses configured", shell_output("#{bin}/uplink ls 2>&1", 1)
  end
end
