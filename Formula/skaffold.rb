class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.39.0",
      :revision => "4145d76cbccd0ea46ee31541f5f550368e257fa3"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3b048506e0f269b09f0945fbc392cd8ec1aefc7bc8dc22ff8fce4a740478f6a" => :mojave
    sha256 "9b4b6720b35876e19b4953f697b726e9dc6400901c0d223687f48a76e2c3c870" => :high_sierra
    sha256 "18c2962dc03e5584fccd726cb5e7d93a7e0de169cc8a80c2cd22103d2da4ffe2" => :sierra
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
