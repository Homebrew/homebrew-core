class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.99.3.tar.gz"
  sha256 "a3a5199d987e27fd1fa1f951c22cb0fb0086cf2f2f6b45402ed1169144727d18"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "339311b73cf126ed1d0f1e7d36f22e2cfc9ba4c428015fa3bad8a83e8cb8ac59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "672cdec1996a41843886f2e99ea29f56480c888968b598d552d8a018075784f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a924a01590566aa61d6768b3839fc6ac0044fac62d5a9e47df0425a228472ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b11ccaafbcf17ed2009532b23654560b8de54fdd9ae71c86050a2786d31353a"
    sha256 cellar: :any_skip_relocation, ventura:        "d8440a81d7fd879a513c8110c3984110e5f2b0142ca75fbdc3b6bb29539e87ee"
    sha256 cellar: :any_skip_relocation, monterey:       "271c2b230938f63337796b286ef316ae6be910db03515e9cf43fa32c674284bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1226313fd34a0687cf9593a4b2884b036e8e5696dcb7637d38e6949450c5ff5"
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
