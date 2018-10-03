class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag => "v0.15.1",
      :revision => "32278ec939d97a7cf379a47045e8d6bbea2baef5"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "45bb94f701aef1429dc6fc42c728ac32b452b1ba18a47d78a351ba7cd496ca8d" => :mojave
    sha256 "775eafc817ae0a87a50def3c5aba90eb9e4ce345e3dd29fbcc3266e8c2d088ac" => :high_sierra
    sha256 "f3772a9d4ba39f3531cdd85dd4ef0a3963789295dad391ed67dffffc81f6db89" => :sierra
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
