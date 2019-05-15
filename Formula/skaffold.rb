class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.29.0",
      :revision => "1bbf9a3f13094e58c90399a4bd7e07250e0d2da5"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe2ca91566f48b279d778807e79a64b6cfbb4b8a7c2d5658b46017a6019f86f3" => :mojave
    sha256 "bafe72e92cc6e35054d06cc804095c5ff145cd289e259ec20d843cd0f609cab8" => :high_sierra
    sha256 "572ba67a5f6c2f7c4f0a4c678c04c78e8c023f634366e79bfb065f0b8f748829" => :sierra
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
