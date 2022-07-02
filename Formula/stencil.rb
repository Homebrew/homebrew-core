class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "636de5ca44c854dd5c587b49150d194fb95c272883c68e52528f8b02a88bc928"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "517ba92bca2d797689b2b04623107687fab7f2311691de77b6350ad08476aa77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b9b1922420873b39270874500f56bd6b5bbf1717a90ed3285716bf594815c87"
    sha256 cellar: :any_skip_relocation, monterey:       "b67a347462ada9f0cf58af96acea325e7db5ad66fa8923e95c68cbab2e1d4a4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d8fa6998564c9ecf19120ddc0553b13eadc16476662f512e5d06c5062c29beb"
    sha256 cellar: :any_skip_relocation, catalina:       "c626d607fdc754a0bebb19a85b877165d5ebb6fcc49656636a43c5c86f0845bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdd607653d595f8e61da6cf585fcf70b3880c2189f480ee3a7f98ecf4ee8c7ae"
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
