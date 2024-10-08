class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "4d7ae67613a5dc6e710f551a528fa136ecdcad7bb758d47d542f0e8b5692b7cb"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8dc046cc95bb71c79805b47df3a912787bcbfe344e9b843120a709ecf55aafb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8dc046cc95bb71c79805b47df3a912787bcbfe344e9b843120a709ecf55aafb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8dc046cc95bb71c79805b47df3a912787bcbfe344e9b843120a709ecf55aafb"
    sha256 cellar: :any_skip_relocation, sonoma:        "60ab1ba8e76fa5ba290df0dd525c9440c0089121d634ee537480911e736d6c4a"
    sha256 cellar: :any_skip_relocation, ventura:       "60ab1ba8e76fa5ba290df0dd525c9440c0089121d634ee537480911e736d6c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c87dea0908875edc52e6bb3d2f7a65582e20162180c48f927050d2572d794f9"
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
