class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "f11cbf581424453bbddca1f2fb114ffb4ab14463fba8c6efe31b4387d7d2c049"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a46a8bd8fd1cff05c09fea58e539fa71ff0ab2a3439aef9b58347472b4c711dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "407a4c7cc9bb35ca7d08d42176fd0994ed9230b02410a2843ea49b1a891b29d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fd86e30198a1a755d79e962fa3185335c5444bd424f0ff0c88a282bef6be4dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdd6fefd5ad1f75d49bdd07302afe29c1a569e5c2257245f63b6c52a4b6e67a9"
    sha256 cellar: :any_skip_relocation, ventura:        "21b4af057726ef8d411b571903a1bca772d7b3c940133d39075c4c9cff9daca5"
    sha256 cellar: :any_skip_relocation, monterey:       "7adbe2eb6cb7ab4af3f416750b2e267027a16f8ff97fec18191732a80a0de52f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "002bf9cfaa6d936a69750c350ff4877f0bb1bfde36d1fbb688d1767ac2ca73be"
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
