class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.21.1.tar.gz"
  sha256 "e0b6c38d72d0defacc5912912e0f629b8fb6f33494995645bc438f81d76daf9e"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbf4d1ebe1e36600710d5396fce3b6b0ac8014f76e2234813e8535a36dfd7924"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c418a14ca606ccf4244a9f24f58eeb2595c849def4c0e340fd6c13ec3795ea82"
    sha256 cellar: :any_skip_relocation, monterey:       "f54d26e68ee1805a73feb669b33124b90df216209eeb2a9fa965ed82e4482811"
    sha256 cellar: :any_skip_relocation, big_sur:        "185c719d9e3d48d0f217e2239cccb1a68b64a18ee14cbcbc5acb12a98ad6463b"
    sha256 cellar: :any_skip_relocation, catalina:       "abd638b636fadc11ccfa834d17448827dde44c1b3fbc0af86432ed0717615751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3523ecd6ea5a94fbce046645b47c2935204b51ac4df13f087272229530ce857"
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
