class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.36.0",
      :revision => "1c054d4ffc7e14b4d81efcbea8b2022403ee4b89"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99fc00800e8ce75163f78c5bcff45ada74ac9267794eeafc6d185b950f130393" => :mojave
    sha256 "e8f7005c7da9fa71837b83b9d6fd38b71b5774abb8168c0451b1e2c9f591bd92" => :high_sierra
    sha256 "f7a1c05e8b39fb8349d90be8c76a41810092ad3773538ba793c43c0f488cbb86" => :sierra
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
