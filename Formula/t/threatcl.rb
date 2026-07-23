class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "c921cfceec54d68bff0824cbe7e88ed1a791d4cdca26dcf83e326ff97a6e49b9"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b65a59b57b3a7246209ff3c85f957a350cba711f9950f918d6e5627aa060173b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b65a59b57b3a7246209ff3c85f957a350cba711f9950f918d6e5627aa060173b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b65a59b57b3a7246209ff3c85f957a350cba711f9950f918d6e5627aa060173b"
    sha256 cellar: :any_skip_relocation, sonoma:        "17ea39f615fd15cd5196ecd7205511855f92eae05c200ab31e0c224a612f6397"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00bc637eeb26c8cf75958423ba36168cd3f2d0520d3267126d172ee13f3fd144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbe64c5c979f29476bee71ac37a6cab550f56fbb086516f448f8bfe28793ffcb"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = "-s -w -X github.com/threatcl/threatcl/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    # Other examples remote-import files that need `allow_remote_imports`
    cp pkgshare/"examples/tm1.hcl", testpath

    assert_match "Tower of London", shell_output("#{bin}/threatcl list #{testpath}/tm1.hcl")
    assert_match "Validated 2 threatmodels", shell_output("#{bin}/threatcl validate #{testpath}/tm1.hcl")
    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end
