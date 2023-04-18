class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "8a2a1e735de43b047371fab50a214d57d07b85a99372ad45d3fe7b9e905d92a9"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82c816555bb045aed0b7441a8ec8dcd5f69c07a7e7a0d3614174dcac7d8c9abc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0c37ae9fd4b286c6c9851536886cb0bc457b73b171c960e343fa814d2201714"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c291cd93b1e6de4fe34a68ce8b3760ec2e06aa9180e77e02aa5b5ab3e2586b79"
    sha256 cellar: :any_skip_relocation, ventura:        "7fd0a90318f1fc75dbbf17dbe0dfb5793c2fafa2962400bd09bb0df65dc067c6"
    sha256 cellar: :any_skip_relocation, monterey:       "871d3b76b9b146a7efb29d524bbeb3e2271315cb9455cd9f4bb8b7f4d7942b4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "185edb7ab7174c3e6d3fff4f5b244b8a1ae6ebfd7c4c90e88019beb5c6810909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a821839fb290081b76888becc98011a91f54afdf87770453eeb61ded4b5f720"
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
