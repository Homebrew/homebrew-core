class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "871455686cc7b0ef1663610ab52f64bf7fca925c7ff5b04e77f373cfd307a4b5"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b29de262f26745b6f50b84cf0d379c8363a936038054d66db07a282b50643387"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b275f36c02a4999d2863a47334592fe658e4088c43dffbf03889067a33e892c"
    sha256 cellar: :any_skip_relocation, monterey:       "762ffde5fe80c89ae06ef06b956253cb75798e45449bd51ad39a612d0d74d9fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cb703bf473c61594d9353f63798806aabd90f9feaae40c865e3e05cae945f47"
    sha256 cellar: :any_skip_relocation, catalina:       "3438c1bf8d2bc7215879e5c1d555d2c0faa92d03c62a440130043c40b4b8c133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d81de0c4b55b18b14d9f3c6475dd44cd42da7feea3b8a6086a3f1a4fe95bfd4"
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
