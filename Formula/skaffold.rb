class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v1.5.0",
      :revision => "6a92475a4aa07180b1340c5bb1aa2b18ae5058ca"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "73d3b07ec56c9dffb879e508c18a37cf04ee96225881d7cfe07c9ebfe2cb1623" => :catalina
    sha256 "0b834be60b424fd644431d7b1fd5ca7d69212e448c6dae9c4c03ed9147adf6e2" => :mojave
    sha256 "0c2e945c4884450698336fb7ebd88d93c15a439188b5162e0159eeff97203d87" => :high_sierra
  end

  # relates to https://github.com/GoogleContainerTools/skaffold/pull/3775
  # should be updated to use go after next release (> v1.5.0)
  depends_on "go@1.13" => :build

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
