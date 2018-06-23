class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag => "v0.8.0",
      :revision => "2d0ee1ef0e40bf9b032ce62e400f26373fa36e3b"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "07f55c54077c6636208da13c567b8d839b1ffca0d16aab71d52259adb7e9123a" => :high_sierra
    sha256 "c3646d217e91d842b760bedcf0af154fceaa0faee75d8153c116db8f9e155101" => :sierra
    sha256 "c749e6b7a60ed51b844ba5b424c0cdf9f1088409ef331cd320e5674b2db1275a" => :el_capitan
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
