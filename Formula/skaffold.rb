class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag => "v0.16.0",
      :revision => "78e443973ee7475ee66d227431596351cf5e2caf"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7452ff958717975d1664931ab32ef1e460d8ad033deb19ea0d756e337268c64" => :mojave
    sha256 "9bf53e263aee7b24c5b416168dfe5d6c1b2bc9019cd1acc5ccaa308bea70650f" => :high_sierra
    sha256 "3f07ff85793b801b6fd67d8c0506d8e175b46cbfa424232af2aeaf57a9f23efe" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/GoogleContainerTools/skaffold"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "make"
      bin.install "out/skaffold"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/skaffold version --output {{.GitTreeState}}")
    assert_match "clean", output
  end
end
