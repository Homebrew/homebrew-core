class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "3992ea2ea126864c9b81c1b561eab0f6642947cc153f98b6b52f355e8aabeec1"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c7cd5979df83fa1509bc54a3c03c6ae233d2dfa09c772e1b0c627502859fe95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da8844881482fb40122fb41e9006dc28b4da28177e95206b9a03351354f8d0f2"
    sha256 cellar: :any_skip_relocation, monterey:       "ef233cbb114e398a5db26bc21c6fb66609f3b95906a65d9be2c0f51f9ad75092"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cf114b51f87cce6716727cea34f8f067f76363c93388a5811b5f3991e7a2887"
    sha256 cellar: :any_skip_relocation, catalina:       "77ba9dafb369e15a6af44d46402b9d157094c13af93af50d7071acef7f7ccbc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eb51fbc44f902fcc61d99dff7479bfff8777a23a93c7bc8b813973663dae4d8"
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
