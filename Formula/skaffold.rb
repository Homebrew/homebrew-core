class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleCloudPlatform/skaffold"
  url "https://github.com/GoogleCloudPlatform/skaffold.git",
    :tag => "v0.1.0",
    :revision => "e265bb780f63894f649b8fb1ac53f8aaf89573b2"
  head "https://github.com/GoogleCloudPlatform/skaffold.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/GoogleCloudPlatform/skaffold"
    dir.install buildpath.children - [buildpath/".brew_home"]
    cd dir do
      system "make"
      bin.install "out/skaffold"
    end
  end

  test do
    assert_match "clean", shell_output("#{bin}/skaffold version --output {{.GitTreeState}}")
  end
end
