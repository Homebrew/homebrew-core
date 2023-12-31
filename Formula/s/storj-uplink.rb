class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.92.1.tar.gz"
  sha256 "36fd4ef47bfb540449bfc2fca129162eee6a7f460bb97776d383c7b0efcfa49f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe5137002b74ecba5136e3574f4c5a876fff67c6faedbf7d0afb11e03c7d8095"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab4b91d857081f21ae8920c6f743a766befe7503bee6cfc0d0eeea758f06dc5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a3071b5eb4821d6f007d3fc3522d84a282b51a90cbe6222919fc8a57bbb0817"
    sha256 cellar: :any_skip_relocation, sonoma:         "524e6f959b9be8f134589700c95b7630de105c3f4e503f77e7fcfb5c93a3240d"
    sha256 cellar: :any_skip_relocation, ventura:        "fd5bc529dc31ef78f3772670d7ade65cb95702484dc9e4c5078884619f08b68b"
    sha256 cellar: :any_skip_relocation, monterey:       "93db6293171633189ed45d96bb92c16ebffad9cc4b85d848546d56ca517f50f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c1699f07fab94d4291eba581db76a86cdac647864540e252684fdb59488b200"
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
