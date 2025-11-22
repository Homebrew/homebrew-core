class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.142.5.tar.gz"
  sha256 "e68892519c9a66e33d7b76a05715bb704b236a1cbb92b194eb0271b89c485e42"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1236d0c346e736f430af2dc49312b5197e02343c6bbe0dfa7af583a801ce5267"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1236d0c346e736f430af2dc49312b5197e02343c6bbe0dfa7af583a801ce5267"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1236d0c346e736f430af2dc49312b5197e02343c6bbe0dfa7af583a801ce5267"
    sha256 cellar: :any_skip_relocation, sonoma:        "76c3a0b7f2e49a2c3df6cc12e163fec3a07fd41b4ba6569169277dfc79f52d11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a67213e6e870440a9ff77bc0c5e19dfddf68c1703ecada8a7996c264278b84fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "873dfa402b669f198fbb0c7d1462ed3b319446195add6e55e91ae9cbf4aa0c9b"
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
