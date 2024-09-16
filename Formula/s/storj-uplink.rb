class StorjUplink < Formula
  desc "Uplink CLI for the Storj network"
  homepage "https://storj.io"
  url "https://github.com/storj/storj/archive/refs/tags/v1.113.1.tar.gz"
  sha256 "fb372519dada8c8f32341266afc68cf3996a9d5ca94a33d0a857f9e15cdc3ec2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "568bf2156e57d1306a46461d3dc656331b8db5ec8f0dc476387e62959c2cc958"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "568bf2156e57d1306a46461d3dc656331b8db5ec8f0dc476387e62959c2cc958"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "568bf2156e57d1306a46461d3dc656331b8db5ec8f0dc476387e62959c2cc958"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "568bf2156e57d1306a46461d3dc656331b8db5ec8f0dc476387e62959c2cc958"
    sha256 cellar: :any_skip_relocation, sonoma:         "24623db05452961cff77763ba93021e08160bd944bbe90ba331caeec933453a9"
    sha256 cellar: :any_skip_relocation, ventura:        "24623db05452961cff77763ba93021e08160bd944bbe90ba331caeec933453a9"
    sha256 cellar: :any_skip_relocation, monterey:       "24623db05452961cff77763ba93021e08160bd944bbe90ba331caeec933453a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7641d688af8b8c00ac182d2080ae13b173d53e0eb06ce4e2e744ca64cc249207"
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
