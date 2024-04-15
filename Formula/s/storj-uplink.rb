class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.102.2.tar.gz"
  sha256 "38a72522aa5177c7d8234260486551faf2fad57a0f925fe76b425f4aaa1d3ce1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dac6149bcbe6b05de104305a6b58b15b4dbb6bcefd39b91aa775452ef4809351"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1274aa1f2a3049f1a9c91f0cab831e555d2d6c83c7666266f2839219f7d257cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1966bd40942fb0d11c5e8ef0902ffdadee97805c95440c252cc9f6cd3a65a0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "549482c41d21d0cd95bc21863fc3781624beaecc18d24f390b6048d9fe4dcf4c"
    sha256 cellar: :any_skip_relocation, ventura:        "be381a241e5481c9d34209cef2bfaec8556d0aa82f761bc8e7a972321b6cf951"
    sha256 cellar: :any_skip_relocation, monterey:       "fa171e7ec694ed7134c55e4ff7e8f9230188abc1b55a58e2a0bc4b246d0d3af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a396ebdaa78f2ac332f98b6a35591f9e671c9cfd2608f611218dde73d270a9f8"
  end

  depends_on "go" => :build

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
