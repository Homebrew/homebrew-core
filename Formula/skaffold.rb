class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag => "v0.13.0",
      :revision => "3cfdf8901c0b2057c2f6cc1331462ad329cd7e2b"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97877dedbe24068c36f0fe9774f028f0964c1cb88c24f713f43712e513429079" => :mojave
    sha256 "7a65e010761d72013f286aeb0326121b6f1df49950b655be5b2949491c9b2382" => :high_sierra
    sha256 "b31b8c30a83e3a22d0175f29524ce4a7c7df690c984fb4dfa34302509dc6266d" => :sierra
    sha256 "d6b99e448c491038703d6682cb0aacaa22d72616a5ab141c429ec6bbe4d08915" => :el_capitan
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
