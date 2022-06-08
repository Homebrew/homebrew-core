class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "2213081996ef173c3de531be760eb40aa835ec30f961527a35afbe3fc2767d11"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa8a9f91b0775b00fcc6d3b93223f7c041e13d923b8722348d6aca99fe342bcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78b992da94ea4cc0ba8e447eb97f64665cea6dd9b9e9949b9313bbf75795e608"
    sha256 cellar: :any_skip_relocation, monterey:       "fc4e0dbf74314460b0957372d946a2386cf25067fc48076d71792a24ec363b6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5e2a484f926e9e40df709acaa88d039b9355cf945570de5bb2a79a522db51a1"
    sha256 cellar: :any_skip_relocation, catalina:       "9a6f4274e5cf09d340862e80a5ae3aed97b4f2d375085c4ce4abd43a30d9b8b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45c2e5655a42fefb0f8dedaccb412c2ed0fc236519f60edc9821e6406784339a"
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
