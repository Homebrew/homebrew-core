class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.5.0",
      revision: "4b5118b88718c5742efd18790aad59d163ed148e"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9d853992a9538e58dc1521ad255c90b2b486e45d6b6e2d5b1756f9e052bd806"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4a103afe1d195af91207169cf86de5e3e321001fcc7ff546a27895f1b4f34dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "633534e41fce84ea25145205319b05e12e96d540db803f415854fc5f7cb6c833"
    sha256 cellar: :any_skip_relocation, ventura:        "c868d171376dbad1b456ac1e32392b4cd073f88d249db86e88c2b86bf0447970"
    sha256 cellar: :any_skip_relocation, monterey:       "cd59b7140d853d00f1e7299a12e2586832696efa4463b579f215d86c3af1f5b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "303f20afc1baa2e6fe8f6567df48af0cbc4610ee7e2fd843368b6188546ecb78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd39d47c7e973394221b882da917c2f82f8d4b734a8841c4fa4fdf59b216cc4a"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion")
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
