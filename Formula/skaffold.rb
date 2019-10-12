class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.40.0",
      :revision => "4058d66b191038f4c3ac27ea2433a2dfccd40c5e"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fa3b24593703367e10169828677c882e8c719a1143a818ebfcb1cdb0c663b6b" => :catalina
    sha256 "0c79db2008e2c4173e6ee910ac57d729c1dd03c61f42ad434d4247f5d256905b" => :mojave
    sha256 "dc8dd5401ffc9768c257e7b10b66fd866fbda5ca7c25db5d21a1eed2379c897d" => :high_sierra
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
