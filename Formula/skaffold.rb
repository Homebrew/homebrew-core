class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v1.10.0",
      :revision => "efc375e822eb76b479d026ca38b18ad02f9f4435"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c028f9f539e18ccfe9c63c535a9b5dec5b22702b16e97b48f1849c88d54f70cc" => :catalina
    sha256 "c96be1f40f3b6dabd9393fe424accbfc4f3708d548a15750de3837875263b2f1" => :mojave
    sha256 "0b3baf9cd887ab522a0462b4cdfe4954f367366c70c1a4e9a9e0014e603a9b3c" => :high_sierra
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
