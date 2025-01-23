class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.120.4.tar.gz"
  sha256 "d688c90cb053db98d1cbdb0a00a1384810db7b2637add6662da5677cfb486763"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a40cab50761a570742245089f0fd04b4cb893a683cf47cc31107de2b65c756f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a40cab50761a570742245089f0fd04b4cb893a683cf47cc31107de2b65c756f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a40cab50761a570742245089f0fd04b4cb893a683cf47cc31107de2b65c756f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9988f66fdc72ea9a7fe7f7329368a4677bb7ed7756642e4f76fafd6cf03f7a8"
    sha256 cellar: :any_skip_relocation, ventura:       "d9988f66fdc72ea9a7fe7f7329368a4677bb7ed7756642e4f76fafd6cf03f7a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5f32147db8735e1c8607e778f54f9543c3c5891eba7e7a5090f987c85ea72ef"
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
