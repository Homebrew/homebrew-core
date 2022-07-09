class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "b119463ede8c6fc75e206158111447f2ebe586f4cc371b180045fc80bba6856d"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b25b94f80cb4b9f17c8c432215463a728ba9b16e3e033fce7c43a34b2ddbc422"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3723f4c2e705305654a57d66f17afab60166b209a805fd4da80da4f239da896e"
    sha256 cellar: :any_skip_relocation, monterey:       "81b4b5359e6309705627f3eab46a4bbbf55e6964a662a1b85aff7c49488f6c15"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c945b5597258b6b6d3a9ed14ee79ffeb5aad0bc4bae82c2be82326b20a2fdc4"
    sha256 cellar: :any_skip_relocation, catalina:       "cfb337f6636b15e8a6a2438a43d886f9b3744bb769d72af90e77143915c071ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00c965e3e98ddff63f26504c3a8e56b83565d37ce0d3f5dd594a203ccc685417"
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
