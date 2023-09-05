class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "a7bf19a58e662a59c3a58d9d6c43c650ec04a2c94fd5068a75afaedf1a8ad5c5"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40ada98d463b65d95dbac88dd24ea83cb17fd37aa5e30e2637dcb6d7371c3e4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "683359f65cfcc0d7fc102f6e5d4432b59937f1c8af6fb1966b66854f4c0c7393"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc426936670e9c8872daf239a229c61beaffa3760798230d1aa01ff9d5cfb8df"
    sha256 cellar: :any_skip_relocation, ventura:        "71b51155b9377232ef24d867309bcbb4f823feed8adcb16a9c67beb29b0ab6fb"
    sha256 cellar: :any_skip_relocation, monterey:       "b1a4764ed7bf5a69491ca550351f07ecd115581631cba0aca06f9da77d4172ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "bea9301090cf88e6bb25e3a59f2b9d9ca2e57260093da7b6d5562237ac136ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b56e7662f74260c3521dd35ddda375d3860d46201019bbc3e53272b2f0fdf7c"
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
