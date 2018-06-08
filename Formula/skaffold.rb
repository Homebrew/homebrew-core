class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag => "v0.7.0",
      :revision => "71021311d4f4db76044e5fcf8d862bd644744e79"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "40e394aa53dc1497633f747e08c4fc6e8c34eff7ca36734cf4a98d9dd36011d9" => :high_sierra
    sha256 "fe99a5e06cf05ae773f3e78b56cdd1863daa88d19fe76e73eaa94825f64f9c80" => :sierra
    sha256 "1a8eb6381da1a4fff1c379e374104170f97bd0d5e481c68e1eff250389afec21" => :el_capitan
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
