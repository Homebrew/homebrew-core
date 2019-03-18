class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.36.0.tar.gz"
  sha256 "570ee5364064715b4b79f6fa989d783fe19eabcb0c623d3dc1b43e0ddd3cd9b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "dde248a9a6dce50ba4de41fde5df71b654b5773de5a9e94e656d38fb99d087cf" => :mojave
    sha256 "8db218b6f1f28a520b064ff0570c244759d3fab34ba1d6ff3ee477e35778c45a" => :high_sierra
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
