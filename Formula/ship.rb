class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.36.0.tar.gz"
  sha256 "570ee5364064715b4b79f6fa989d783fe19eabcb0c623d3dc1b43e0ddd3cd9b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "051174615c9a616cd7df62932ee2262c67ac1eb7b6100147800a7f3e04f9dbf2" => :mojave
    sha256 "044c5f1230f1390fe11ecbc7ad938390493d75fb8d8260eebbff8839d4c22867" => :high_sierra
    sha256 "debdb05f2b6bc5a17e014440ad3d7ddebf88887bd23a6949f3c3f22eb1bbc6d4" => :sierra
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  depends_on :macos => :high_sierra # Ship fails to build with Golang 1.12 on Sierra

  def install
    ENV["GOPATH"] = buildpath
    srcpath = buildpath/"src/github.com/replicatedhq/ship"
    srcpath.install buildpath.children
    srcpath.cd do
      system "make", "VERSION=#{version}", "build-minimal"
      bin.install "bin/ship"
    end
  end

  test do
    assert_match(/#{version}/, shell_output("#{bin}/ship version"))
    assert_match(/Usage:/, shell_output("#{bin}/ship --help"))

    test_chart = "https://github.com/replicatedhq/test-charts/tree/master/plain-k8s"
    system bin/"ship", "init", "--headless", test_chart
  end
end
