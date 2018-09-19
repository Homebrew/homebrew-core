class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag => "v0.14.0",
      :revision => "0f99b31ce724e971af347e9a6f9582f68b9ac250"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a08913a059566a7bbfd484f856784d2c0a5ce08852a40f85fa4912417d4de546" => :mojave
    sha256 "d75aa803c216c942d47a2403ca3efd1645181417cc11dfd0f12a3880ea900c57" => :high_sierra
    sha256 "5993c4689e3d242dec2f911dcda621fc1ff8c0611256a0de57932baffaee8cad" => :sierra
    sha256 "c9e27fbdde451892ecd3ec2d3eff63eb3f4cb1801537249e5800cc6436445de8" => :el_capitan
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
