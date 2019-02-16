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
    sha256 "daace39a2fdfaf12d45aee2df69263083b820d43561067fc5fd61520ccaff0e4" => :mojave
    sha256 "0035f823e3e1781fce808ef1f3bcc5dee757af3325812aabb4f8807bf1c0b2c0" => :high_sierra
    sha256 "6d6c6f32b1e1ce102d482b4d210879fc4898fc0b0912ef2cf226148ddf23d96c" => :sierra
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
