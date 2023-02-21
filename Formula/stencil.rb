class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "45ec2921d4ead2073f6370ba489ae30bca7cd0e2b90fe4a0a3a3ebc1808e8fc0"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5678df746fd1b21655d60d0a6636889eeb048fd3c54b9614db75119678733080"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2643dc095faf324aabb0713cf3d7154d0070b69f86715952ad4333c5ac2b0bed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46bf7d9c8352ecb70e90163959b19641e4f26610254de32173fef49117943c62"
    sha256 cellar: :any_skip_relocation, ventura:        "f2692d9981cbed8ad0513bc2ab934f63d574ad56dc6ee6030cafac5aeaba6d97"
    sha256 cellar: :any_skip_relocation, monterey:       "0de84c459ac9e9d6473cf3b78a324aec3c24a80d62a7bd1b3f97d6e6757d7834"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb5d0b1e85546856c5713291e01d9898762dad4813f0a16ec101e2ac7bf3ffd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9404fa6e22dea194b2bf75dd4015c9590f33b51e836020018e4311741b87220e"
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
