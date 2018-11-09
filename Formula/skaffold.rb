class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.18.0",
      :revision => "34651689be78b2c6bcfbace5072b00b93661f895"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "85874bf1826ae861181cb132dc3dfb0937820b184e977529df451be9313e4e1c" => :mojave
    sha256 "291a04d5877b3f3055d9a1ee26d7df48a2431307f445b595ab6b0e398d98fe98" => :high_sierra
    sha256 "6f743845fc2f0619ec338cba95bf3d314833d21b437542e53645885c0ae5378b" => :sierra
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
