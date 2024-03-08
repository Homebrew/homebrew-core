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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e95de4826549586e2c1d8aef4b3aba90340a01a838b91eb4b9ad3b231d20163"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1285be561407b781925c35b0fb74f49942ad682bdac9f8c94326a1968c80119a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5c28123f32a0fdb6d8a3633c915ef2b2fb3dcdec3012bba050be035825f4f25"
    sha256 cellar: :any_skip_relocation, sonoma:         "674ee0709a38d71cb11b77516456cccd459eb15b27b632498a84070c99db1929"
    sha256 cellar: :any_skip_relocation, ventura:        "0b430c8bf8722ef51d536e34e7bbfbacdb07faa16cd7a4c1de96826577169041"
    sha256 cellar: :any_skip_relocation, monterey:       "312ca7472a116502b4629b81175a21d8fb58240c3e8cf3be42a5525a337b5e80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0abdcbf955461d58c059ba4707e7116257b5506a7ba0677a81e51f484343f97"
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
