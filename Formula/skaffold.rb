class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag => "v0.12.0",
      :revision => "dd9fb3c19e9f49859f57868de2d8eaf99420705c"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
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
