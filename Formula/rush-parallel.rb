class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "51e5ad03a29a36f26f8e9157590e8c620df3353828f9794dd2e45cab43292cef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd3260f7043e4607d7f90cb3c8c0fc9d82b485dba4977fda806400912864a3fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3544767885bfaa9008fb299545e004ac6fb25c0cc2ae5bfc7616dfeafe1ca0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5705f7b0c32ee8028014710e5a0a8b3a1048ec4deed4b2764b40f77d010c0ea"
    sha256 cellar: :any_skip_relocation, ventura:        "fd091baadc9707b283d27ebfafaffe4d454321d5dbf5527e77b23e434a407621"
    sha256 cellar: :any_skip_relocation, monterey:       "9501d28e3d3c2898a2d01f8c40e8b20a7aa1a5b23a152553fee9060798a48557"
    sha256 cellar: :any_skip_relocation, big_sur:        "114115e860f5bd173e013acffd8430cd49b5a14f5679a76c84aabbf1b5ca57ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "368e651636e78e764c25f9546d8e12dbf395ebc659a0457619affe195a2fc1ce"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"rush")
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/rush -k 'echo 0{}'", (1..4).to_a.join("\n"))
      01
      02
      03
      04
    EOS
  end
end
