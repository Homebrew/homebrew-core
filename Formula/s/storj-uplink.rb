class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.89.5.tar.gz"
  sha256 "85cae50881a23e024c3d9b70b2c3b79bffd109c01f3d44de982f9f28808c97cf"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4045740642b6c88c98e3728935a78711d1f23cfc74567d1f048c9f635822bff2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33a8f4ecb445ea8e26300ab1d7847492168e7e2a02d56196a6414e6adc2f33da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "495b5c534440c72d2f483dddf76352d1b243a76053b3d5c1f58737df7190fcd8"
    sha256 cellar: :any_skip_relocation, sonoma:         "af8fabf413bb98a4f99e77c9948cf4da64be65261da0a4bc030b3c149fb43698"
    sha256 cellar: :any_skip_relocation, ventura:        "b2ee45f9c2a947aebcfbfe1e9a94717efb0ffc80595d8353283a8c8978626725"
    sha256 cellar: :any_skip_relocation, monterey:       "b18be3d79acae668775ff735bd8f188488febfc8c6f164ce528ab2cbda674ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a51451038e200e9a661c6b1feaab5f50f2c46e2ac9c00fbffcd8b4ed8ac59b2e"
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
