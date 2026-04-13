class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.151.4.tar.gz"
  sha256 "6e104edfad225992434e0e36d66704167a963f3116c5284256a08d4183cce777"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1c47bfa1286bc35d0b13c4899148c09194311bfe66eae209b120ddf57099e28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1c47bfa1286bc35d0b13c4899148c09194311bfe66eae209b120ddf57099e28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1c47bfa1286bc35d0b13c4899148c09194311bfe66eae209b120ddf57099e28"
    sha256 cellar: :any_skip_relocation, sonoma:        "30529ff2316d532d0f41a011386b6c2cd9be2b4862730affeb81a8e14a7e29fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cceb68369bcb139d92ba6b0d6ff13c34b063fd0b2fd5e3dc25a44e4702d62fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aae3b65cd586326ade37be56fce770ac4a9c86f18c4853fa5a106e542e621e10"
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
