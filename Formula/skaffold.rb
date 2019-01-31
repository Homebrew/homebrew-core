class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.21.1",
      :revision => "a73671cb547a80d3437f78d046bc500269673ea3"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d526e1a50be85e9b25a434a7f06efa0abbff1258fbf2ab55f8e17bcaf8ae96dd" => :mojave
    sha256 "fd3460c834c53c8951bea303d840102b79293e1ead25d8a08ce6d36c82bdd307" => :high_sierra
    sha256 "64b8b15aaed682a7223f41a9528e701ce03833f448ffb9d8014bf6bd35cedd39" => :sierra
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
