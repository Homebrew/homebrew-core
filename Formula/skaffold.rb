class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag => "v0.8.0",
      :revision => "2d0ee1ef0e40bf9b032ce62e400f26373fa36e3b"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e014151bee18d2affa0c3d5a7f45de4172a43e25628fa4c286732e68380dc5d6" => :high_sierra
    sha256 "a5b55071984c39b431e1c35b407b4fedb68c3b90e289b2af2555c99f66925a2b" => :sierra
    sha256 "81ee1c99869f2dd727e104ca55c9485c992682f2b2bcf358487a57a8a07d8b72" => :el_capitan
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
