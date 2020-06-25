class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v1.12.0",
      :revision => "e680a831292e1c7efc54e0c6d40544ae141e6354"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3fe831ee274a385198f3c4feaed10432d90ab0f2451d725732c7ae8441fa526" => :catalina
    sha256 "437c7bc56fa3aca83ccc0d415a69e2f82a9fbb219b63c1f483547a2047ebd6c7" => :mojave
    sha256 "aff599dc873608227836e75bfed176e4dfd491dc370635f8f09faac9b6d5e7ae" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/GoogleContainerTools/skaffold"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "make"
      bin.install "out/skaffold"

      output = Utils.safe_popen_read("#{bin}/skaffold completion bash")
      (bash_completion/"skaffold").write output

      output = Utils.safe_popen_read("#{bin}/skaffold completion zsh")
      (zsh_completion/"_skaffold").write output

      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/skaffold version --output {{.GitTreeState}}")
    assert_match "clean", output
  end
end
