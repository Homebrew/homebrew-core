class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag => "v0.11.0",
      :revision => "9c16c5946aef6d952b661bc4bf0a337fd4cb5a4a"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cccaf535a208b6ac9082360eca2387bcb9151f0c1befca3c85b4fbff9cb4c60" => :high_sierra
    sha256 "bcb35ac9ad0582d80f0bf2ebe99db9cf7cdd80f3f5fb2388b4f12d13a8ca7663" => :sierra
    sha256 "73b3537bd118382cb3bdcc2e8777299547fead1bb3338cda6b89396e322a7ed4" => :el_capitan
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
