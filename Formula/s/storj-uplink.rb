class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.166.4.tar.gz"
  sha256 "31d9e03e361ba3fe2386d6c088509577f3bbfc345ec47f1d1f559330540233a7"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82e3f53606c362a010816172623ec7f030784f4f75e2658c8ee4081d87a85578"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "82e3f53606c362a010816172623ec7f030784f4f75e2658c8ee4081d87a85578"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "82e3f53606c362a010816172623ec7f030784f4f75e2658c8ee4081d87a85578"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8b51cf0ad3f75ac35bab4d28678faaf8e3af614c49016d864cb7f2f0e1a81ef5"
    sha256 cellar: :any,                 x86_64_linux:      "35f02fc602e85ebeb571866b28cd4580b1c6c7224aba72138e307409c6ca9d82"
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
