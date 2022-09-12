class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "90c8f314648880d7cbca950fb69e70f5a7f0b120a55ad86b345027724d8fc8a2"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40982c7f3eab8c0baba5c5d76d6591d7228d74859a75de925b099268acd3512d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35dd9dbaec7b16e65e107179616f91f8b67d53192326cdd41627ebe9f4062ccc"
    sha256 cellar: :any_skip_relocation, monterey:       "d79b782c0eebc7bb9ec2f146a4e8c83a80e0379039e9b945955d7d8d036325f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "41405dbf89bf10bd7993dc60b659e78d0e8f8c9ccedafc5b279aecdfaef91f60"
    sha256 cellar: :any_skip_relocation, catalina:       "12938346327cfd9effc008c175101cd5e69ca692f3b642cec8d77d7d4da5c7ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a529ade093f3e92b1366fefcbe61f11cb7971cb45f59da58625a6eee6ea62b7b"
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
