class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.162.4.tar.gz"
  sha256 "8153a15b677c71de595975f4d2bb031560f33fd5b1bd29252b88d36a7128a67a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb4b53a791bf9fed9cd20e14b35266246b0f211aacfbfefecd4978e251120c5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb4b53a791bf9fed9cd20e14b35266246b0f211aacfbfefecd4978e251120c5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb4b53a791bf9fed9cd20e14b35266246b0f211aacfbfefecd4978e251120c5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "757eec8fd5a3e30df11be01593531407ad540771e3ae5782bc63c2fc085eaea6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42bda49364a4b3091956293210efbbbd23e3f04a6cbc15b4b0e1f9f45b3f8a41"
    sha256 cellar: :any,                 x86_64_linux:  "030893b51b15f8e3737e0b8b864f35e52562c0da69d1647da138cffcf0266df3"
  end

  depends_on "go" => :build

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
