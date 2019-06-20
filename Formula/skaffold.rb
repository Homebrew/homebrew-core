class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.32.0",
      :revision => "6ed7aad5e8a36052ee5f6079fc91368e362121f7"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2926e45d671833869a8adc5b51c605b364eefc59f5b17f2aafa40468bbd6915" => :mojave
    sha256 "9e96315bad3fe73845a268cfa56d94bab8eb2a2c88994d24bdad5f02f358d16c" => :high_sierra
    sha256 "8f1578b6cca66e4e205a9667669bf2b35db0aaf64a48cd17e5aba0cefec610a5" => :sierra
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
