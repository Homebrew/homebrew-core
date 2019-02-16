class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.23.0",
      :revision => "2590e9d480ffb63e9d954fd1e317b93d5b3d3b9b"
  revision 1
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a486a56fb0ad57ada8250cfb3a318374d35e00a5a2b07921d730391a869b0041" => :mojave
    sha256 "d06a6b1700bfcc48aecaf5920e027de02bdaebe6a022bf34efc74c2f1fb70047" => :high_sierra
    sha256 "119ab8620f5ce53ad482dfde3da49cad035febfc54815dcae1f26ce3c61aca80" => :sierra
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
