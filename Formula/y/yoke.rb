class Yoke < Formula
  desc "Helm-inspired infrastructure-as-code package deployer"
  homepage "https://yokecd.github.io/docs/"
  # We use a git checkout since the build relies on tags for the version
  url "https://github.com/yokecd/yoke.git",
      tag:      "v0.12.2",
      revision: "ad72f69e829742da00f44705a5b2afeca5a00c49"
  license "MIT"
  head "https://github.com/yokecd/yoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b89c8d5a0845db6cd5273fa3600a7ae3a776fe1a638aa920b688251d47aee2a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed1285162e4b44398cb10b70bde602d4b0b7c6ac7c2ca3f8f951db8cf568c07c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6753c51eb332b262721b7dbce55f3e5e478ed349254e8c5bbbd1267fbda4478"
    sha256 cellar: :any_skip_relocation, sonoma:        "38a6a9142d3564c03d234f0e300645b766f0d013d177ea28f677dec0df4ca8f1"
    sha256 cellar: :any_skip_relocation, ventura:       "bbfb132f2449b42d2e186d6732e9ddda2f90aadea5788205364af1b9fd84d6bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "365349d3a99fbac554318df66072b6703a2c05e484f524e332ba750ba92d0d5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66aabc9d4a6afc91016553e058627b862f2ba9585b6305f823ab4dd5ad354cd3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yoke"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yoke version")

    assert_match "failed to build k8 config", shell_output("#{bin}/yoke inspect 2>&1", 1)
  end
end
