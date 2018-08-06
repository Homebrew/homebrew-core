class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag => "v0.11.0",
      :revision => "9c16c5946aef6d952b661bc4bf0a337fd4cb5a4a"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aee5ab167eb727151abddb6d007322556ec895a976b5c5988b917eade5362d6d" => :high_sierra
    sha256 "a2a3524bd61348633dda3cc98caa76b193be781277eaa9dfd357e6ce1ce23c74" => :sierra
    sha256 "d895817d91053b745ff230cfc1e37bcbbbc329317487b5f92f4b81db315e7340" => :el_capitan
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
