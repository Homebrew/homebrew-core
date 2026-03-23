class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.149.3.tar.gz"
  sha256 "98db47857c461da2bb4ad103082b8a164e4765bf781b5a2d4ce5dc828a1310f0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95ef05e2d280c91e6a030991ced0014151cbf9e0806788d1d504e9833f5b4f77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95ef05e2d280c91e6a030991ced0014151cbf9e0806788d1d504e9833f5b4f77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95ef05e2d280c91e6a030991ced0014151cbf9e0806788d1d504e9833f5b4f77"
    sha256 cellar: :any_skip_relocation, sonoma:        "f61a13167291d0f68faf00e9b8a0f8bff649eebe2a4446a8678545a0954e7871"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f70bb6e187c8461eacdff9aff096ca250aa19df3e688a9b10c8a9b4846e64c6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b129b6bcab82a7ce558a3b7e23c7510f20c9d3840116e091ee569fedf5aedb6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"uplink"), "./cmd/uplink"
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
