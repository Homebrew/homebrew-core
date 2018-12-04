class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.19.0",
      :revision => "9eb0dfc1bf634b97462c66b4dfb80e4cea378ade"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0d1e5c797c90b2ec95fda3b09ec081fec10a3559d13cc1c92fb99c4dcba5a7e" => :mojave
    sha256 "b77027bef1d2e81a988e908d7f79792d0be2196d7b5de1884991a7d259838657" => :high_sierra
    sha256 "efc931749e9535749c85eb6a5995a55e056e52e8b7f214ce5186abad861c6810" => :sierra
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
