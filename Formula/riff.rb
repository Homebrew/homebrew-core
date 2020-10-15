require "open3"

class Riff < Formula
  desc "Function As A Service on top of Kubernetes, riff is for functions"
  homepage "https://www.projectriff.io/"
  url "https://github.com/projectriff/cli.git",
      tag:      "v0.5.0",
      revision: "f96cf2f5ca6fddfaf4716c0045f5f142da2d3828"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb64974514f8c764d7479cce8f92cd0a2cbc940e96300b823c684f4752d5b734" => :catalina
    sha256 "dd08e62ae58c92239ea1c321b7a3eda01b83912660f2769291cb0443fd128f9d" => :mojave
    sha256 "06f5da9420de8bf9aac4a16f93effeb2e3ceb83fedc44a5d1c375a2a6f9f52a4" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    cd buildpath do
      system "make", "build"
      bin.install "riff"
    end
  end

  test do
    stdout, stderr, status = Open3.capture3("#{bin}/riff --kube-config not-a-kube-config-file doctor")

    assert_equal false, status.success?
    assert_equal "", stdout
    assert_match "panic: stat not-a-kube-config-file: no such file or directory", stderr
  end
end
