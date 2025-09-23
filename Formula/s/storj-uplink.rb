class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.137.2.tar.gz"
  sha256 "ea584f1ff4e51877a6ff54df97f79369b9ad56555103ca9ae77b095040b3fed4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77a7cd16d0434f450be05714c8d5a5515312f3efeb7606df1820ae5d116c6927"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77a7cd16d0434f450be05714c8d5a5515312f3efeb7606df1820ae5d116c6927"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77a7cd16d0434f450be05714c8d5a5515312f3efeb7606df1820ae5d116c6927"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77a7cd16d0434f450be05714c8d5a5515312f3efeb7606df1820ae5d116c6927"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1863a3c02cbe3414ba1ab885896489918bd06df6604af8e64e88535ee567f59"
    sha256 cellar: :any_skip_relocation, ventura:       "d1863a3c02cbe3414ba1ab885896489918bd06df6604af8e64e88535ee567f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43d24ced7d316a5b7dc63d7825b05b6f369bcfdab83c620ab73d4e5e5f48b64f"
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
