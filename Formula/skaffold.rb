class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.21.1",
      :revision => "a73671cb547a80d3437f78d046bc500269673ea3"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7524c533363cb6fe42c0f48008561a4a629bb0de2e030e2b018e21e5b80f1f6a" => :mojave
    sha256 "c51a01b85ef20cd87676fb17022599669b9be4618a3f44f0cfac67b13bee9729" => :high_sierra
    sha256 "227ae5e082d351ac9edf2167c6c209495eb3c0f936de80b3826ac987fef6a033" => :sierra
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
