class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag      => "v0.22.0",
      :revision => "2187105aae414f500789ca6873898efeb104d7a7"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "48b1791cd0fa9bb6b8cee655f8dc93316fec1e5f3f8bcc28a3530b5fa8bde478" => :mojave
    sha256 "35a9588eca52b3b37a99e3f49f6a00d56e069336bff1e35da05e062825e73de2" => :high_sierra
    sha256 "7b1da6faa7ebf5e56c38341d127368975104db06f4f52788f2b0bcf12e14957f" => :sierra
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
