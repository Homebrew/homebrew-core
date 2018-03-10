class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleCloudPlatform/skaffold"
  url "https://github.com/GoogleCloudPlatform/skaffold.git",
      :tag => "v0.1.0",
      :revision => "e265bb780f63894f649b8fb1ac53f8aaf89573b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "68a77f550ceb7ea5f4e4ef8f34601b292f7e1763ac7b7a18ef5dea2405dd831c" => :high_sierra
    sha256 "9bda4e0fb918af6852642dfa15926d77519135269c4ea029e3f672bb8261180d" => :sierra
    sha256 "21ca4166024ce968cf365deba3ea786e7815531752dc6403dddd007c29effde4" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/GoogleCloudPlatform/skaffold"
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
