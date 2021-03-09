class Rke < Formula
  desc "Rancher Kubernetes Engine, a Kubernetes installer that works everywhere"
  homepage "https://rancher.com/docs/rke/latest/en/"
  url "https://github.com/rancher/rke/archive/v1.2.6.tar.gz"
  sha256 "7782b7a220dcce8bf31d195491d11fc0dabede21d0e40474b27cc2935a37d7a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d9c482fd2489415347b7d7953d4edd3f09263358f63d387de344f535fb2355ca"
    sha256 cellar: :any_skip_relocation, big_sur:       "af8d388a9e0dc832ae69ca205eddca8ad772b8ed4f8e5546e739759da8a24cfc"
    sha256 cellar: :any_skip_relocation, catalina:      "1b51f6c56425f93ef3e06e2933f0edd6b1bbda842805cb6596060031f491d557"
    sha256 cellar: :any_skip_relocation, mojave:        "9dbfd69ad9fffef2d9246222f1235efd3b532c24e299d728b0f7a87cfd5d90e3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
            "-w -X main.VERSION=v#{version}",
            "-o", bin/"rke"
  end

  test do
    system bin/"rke", "config", "-e"
    assert_predicate testpath/"cluster.yml", :exist?
  end
end
