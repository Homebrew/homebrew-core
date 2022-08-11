class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "3992ea2ea126864c9b81c1b561eab0f6642947cc153f98b6b52f355e8aabeec1"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53c44b943e9c2c8c71c1dfcb24276d6cf197bb6e9bdd60c568a3b9430c56e199"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54c52cb287e9e15dbb66306c0652d2949dc2818e7c315390d9b5f120551ee96e"
    sha256 cellar: :any_skip_relocation, monterey:       "1756ad8a9d3c1eb76bb6d671714674409b6cca0cc0fb7f59420d35d9715a95fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab0d3aeb46b8ce2e4f2239688d326844155bc756d68c5fe10159d2812351145c"
    sha256 cellar: :any_skip_relocation, catalina:       "67703dd419b6af20ab4c76dcdb613c678e8d2e4cc8c4df1d9cbd61eee8375738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6af37202aa257b33b168b7ec4d9f0c8afce5abcb71b5a9a398c2bb0f91f0d849"
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
