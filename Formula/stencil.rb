class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "ebb66f5be2fe8ead0b191f414abc132ec6ec5c3497cfce93ec80d846400c9e49"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd343fb7b2606d0deccd7d83294ec5a252b5bdb1b6e571db751c52e1e94c8b1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "332a60f7bfb519e1dad01180e5ab1f2edc77c4aeba3bac93306a9e4276313b9a"
    sha256 cellar: :any_skip_relocation, monterey:       "15af2c5afefd7df00165fa68f6f5ab34746ca1143bfbebc8af9cddddd7ac5001"
    sha256 cellar: :any_skip_relocation, big_sur:        "44773a2edb6782f3427ce589b3aa16aab625a28cd47e346407082deda9a05fc9"
    sha256 cellar: :any_skip_relocation, catalina:       "d235f26e112f80416ed5fdf3a70c5278d48208542382c9e69b619f5365e44218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88d9f7fbb896787d0a057d4c86f6edd5002c8dc6751fcde3db8f90717a054454"
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
