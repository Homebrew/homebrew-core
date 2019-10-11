class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.40.0",
      :revision => "4058d66b191038f4c3ac27ea2433a2dfccd40c5e"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d76f2eef58f084582878026957e1b3e1449649cfba50b819e92c61c726218c3" => :catalina
    sha256 "55de19a1b821b8a4b4b7d9eb3aa207545b597dc4f53ec55c15debf92f586e355" => :mojave
    sha256 "064bccbbac8d4ae1dab14dd44ddc2c928994a84649eb5ff7d32888bb00edfdec" => :high_sierra
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
