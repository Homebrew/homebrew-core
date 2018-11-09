class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.18.0",
      :revision => "34651689be78b2c6bcfbace5072b00b93661f895"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3cfed2d4f0395eb9276765bc01a60cc4c407115956d6462979e58cc2733c033d" => :mojave
    sha256 "11fdfffe9394754fcf9f44fcb6ecbc2085c58f43d785c59bb770fa297ada185b" => :high_sierra
    sha256 "db9c71717fd0f8bf0a6f5a75382991a63592bec1aac07f2d8165b97bd52a1081" => :sierra
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
