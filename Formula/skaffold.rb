class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.28.0",
      revision: "27271dfcaab56c38ecf41f4b7158101d44c454b6"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "73e501288d9935f39e57a5f186fddb5b8d21a4faf4cc6b926cf8b456ade52c1c"
    sha256 cellar: :any_skip_relocation, big_sur:       "4fc569cdecca8008ea3b5ff94e360e318e759ae5a64b4aed0d145d5f37888a72"
    sha256 cellar: :any_skip_relocation, catalina:      "bfc37560c05d71dc0d9febdc950c03f84eeb20b01359a5ecc1b691017c9d3d0b"
    sha256 cellar: :any_skip_relocation, mojave:        "cecd0f629aa60a7dba0855f1db97c317c4011c60a826a40f15d3bfe493f39fd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9a51c73259aef314aa792d22c5b6b78b8d3a2eec8067e7b699dabfefcc68e40"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "bash")
    (bash_completion/"skaffold").write output
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "zsh")
    (zsh_completion/"_skaffold").write output
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
