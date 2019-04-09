class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.26.0",
      :revision => "d88680e9ede62da65500702670ef72fc9272a06f"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d2d590560e186a844c0b9fa39b9e11cc3b3ac60c151dbe88b519a1e7c0f35c0" => :mojave
    sha256 "7984b8ede9213cae0a1582cd5539cde3d3d6b09ae6b6939ac7c4ab3f00647d8b" => :high_sierra
    sha256 "ce13d504583dff15db4e8dbd3557f65cc3bd0d716d039644cb000de472ab5bd2" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/GoogleContainerTools/skaffold"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "make"
      bin.install "out/skaffold"

      output = Utils.popen_read("#{bin}/skaffold completion bash")
      (bash_completion/"skaffold").write output

      output = Utils.popen_read("#{bin}/skaffold completion zsh")
      (zsh_completion/"_skaffold").write output

      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/skaffold version --output {{.GitTreeState}}")
    assert_match "clean", output
  end
end
