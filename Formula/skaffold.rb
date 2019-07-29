class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.34.1",
      :revision => "a1efe8cc46e7584ad71c2f140cbfb94c1b4d82ff"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1da05f43c9018b8edea3d77e2a184b2273e2629d4c3b10366f3ef7d9d6c21d8" => :mojave
    sha256 "2ec0a0824dad0d41df26ad4be76f98652a2054dcbe350a420caea78efde9ba28" => :high_sierra
    sha256 "2b759c70f98d9b4dae65bcdc3d4bcef47fa1196d0cb8ea3183cbc15e74180b26" => :sierra
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
