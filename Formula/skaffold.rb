class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag => "v0.13.0",
      :revision => "3cfdf8901c0b2057c2f6cc1331462ad329cd7e2b"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3563e9f1bb278e6dbaf4b7fd0a4e21fcde9cb9394b1dec1e055b27e0138dadd" => :mojave
    sha256 "4bdb14dd11c9d2fe0ab7f746e2f43546376663151fdfb7e41b6a1a9f6c212b03" => :high_sierra
    sha256 "0fbd48920c04f0547de9a370510f489ecbe2733198fc04bec70f130e2ecb31e8" => :sierra
    sha256 "50ff3d28a429d0547cd63e578ca70551953f9f2a4da736dcd04edb965fd90d24" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/GoogleContainerTools/skaffold"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "make"
      bin.install "out/skaffold"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/skaffold version --output {{.GitTreeState}}")
    assert_match "clean", output
  end
end
