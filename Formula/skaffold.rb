class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v1.5.0",
      :revision => "6a92475a4aa07180b1340c5bb1aa2b18ae5058ca"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f30f6bf8bca7887fee63f793a27599e4fee02727e2f5d27c5405e78fde2176a" => :catalina
    sha256 "ea94ab192d08264104ba7dab33934435c155dbd314e1acd464690ad3c89d3081" => :mojave
    sha256 "ab839262b9450e55b1c580f571cfd14daa068ad913f0a6ad5ab7ec5d2340edd7" => :high_sierra
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
