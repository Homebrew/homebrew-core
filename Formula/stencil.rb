class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "55cec89ef150ecb02b1bbac1d4f3b55a91c24caa45d5c0ac569782c659d82858"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e0d72a5a20d24a397c6a29382fa3e114de4069bec26ce2b256839a81c6681da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65fbe2f65bd6256acd0b765ce9a32878e5c81e9251a54a1db08063970bfde819"
    sha256 cellar: :any_skip_relocation, monterey:       "f59fac2c5790ec978dbeb7521fa371532043d2fd9e07789296851bd5e8daa616"
    sha256 cellar: :any_skip_relocation, big_sur:        "81b13611986bdb9f436863e2519f46fdb2057f835403267245b6f7965525f59f"
    sha256 cellar: :any_skip_relocation, catalina:       "b3a50c058647bccee50ce5f0c9661fb3ec9001ddbf863839765f6ca46bf08d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b3a559f3262b2bec4d174b381d8c634d424fd2db7df4a54cc61a11dff18c464"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/getoutreach/gobox/pkg/app.Version=v#{version} -X github.com/getoutreach/gobox/pkg/updater/Disabled=true"),
      "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_predicate testpath/"stencil.lock", :exist?
  end
end
