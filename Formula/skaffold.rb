class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://github.com/GoogleContainerTools/skaffold"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      :tag => "v0.9.0",
      :revision => "7302a37b6e2d02c0a71d4079c944262381245277"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d00bf06ad62b06bb72329103abaf4781d0cdf727c450202e2cc1e0f9ebf2ddd" => :high_sierra
    sha256 "72471e0483efc44da8e7949d0f8c6e661f36f3664d0f5ccf6ab6bfada87f6685" => :sierra
    sha256 "168e7230e96b3375abd4575abba6add892cfb874d27f3e37882eeaf2d0c81256" => :el_capitan
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
