class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "2213081996ef173c3de531be760eb40aa835ec30f961527a35afbe3fc2767d11"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cf9965c53d51f451c76402abb58701af1d90629149ee87c820e8eaa6aa7ea00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "996c0181daf28063384ed34aae9c97d046717666fb59e277d0bbfa8775209de1"
    sha256 cellar: :any_skip_relocation, monterey:       "a87b11002a2c1b4bb637590d261821b357845c23f8a7fb2dd539448b05a2f8e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4986850cc97fd14dd4076edb35429bc9e93968ba7944a1615eb5f6d82e615c6"
    sha256 cellar: :any_skip_relocation, catalina:       "f812d4468952741961f05c787af6ed76ce8af3a6f603304c4c8b925c0308a872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6037170dc9f7317d746a827b32a1145ae0607d6b466f1128f5df1bc2e88114a2"
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
