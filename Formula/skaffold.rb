class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag => "v0.16.0",
      :revision => "78e443973ee7475ee66d227431596351cf5e2caf"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b60fd976e78a07fffb0d91dc3a6fa6a5407596735547023efea006e46e9dc58f" => :mojave
    sha256 "3ecf88e4bdd1d8394c656f18585d558fb68fce84e1cf869cb113d0ac3453daeb" => :high_sierra
    sha256 "fcc6957d75495d1d346894492ac2ccf307b3baa27980d9fa84a0ec7d57f33fbf" => :sierra
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
