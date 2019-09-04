class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.37.1",
      :revision => "b58aa4ec019c7af0599e0c85ade91f438c341008"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4530353bbf085d80249a978ca2615dffebf861fbe904d3f151fbca513f33ef71" => :mojave
    sha256 "8d5512912b70913ec50457d016afef0dc69f4725db3cfac6aa3a35d227082dcf" => :high_sierra
    sha256 "87527891248dead97c227d04ff1f2d3d99e4f8aa266c97700c77026a3d52afcc" => :sierra
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
