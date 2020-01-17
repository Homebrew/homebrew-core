class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v1.2.0",
      :revision => "80f82f42fe271aea1058f4a37776d52ab5a7c441"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "58959ee3dfc8798704724d1fbc78431cb9c7f65993eeb79d9777e35667ad7ed4" => :catalina
    sha256 "f6e43b7276ab84965e172fbc65d4216dc75f5b40490a95e873fe174467fc5be0" => :mojave
    sha256 "fe31564bc2becd7d821c6b5520b3361c3355b85bf2ae8b0fec476f5ad38ec647" => :high_sierra
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
