class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "6ca667d4483efcb7900d05d08f04e1e20c10e1315746f4f80b04ca5416dddbb2"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aacc0e8949d7a0c167c5aa0c949d3e82969e0ee825a75e70d3a9ab14f129bf65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92c342586b4309715d147311d6392eb644dff262be7343b099e0514acdfe7368"
    sha256 cellar: :any_skip_relocation, monterey:       "8674e50d91fc868c2a0fa6b6446e3d3c095768d06f4cfa68437d40b3300da3f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "45d3bd14a3c1bfd97c67698b2b0ffab125289c89341016754fabe0797f2634dd"
    sha256 cellar: :any_skip_relocation, catalina:       "223a2c9cce93d438f78a7cf5e93cc9073d84c9142f6ee57ed84626c8ab34500c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff24b6d02a6ed5388373470b13fa87bc0c92aabfb3818a11d3b383a799d5a981"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
