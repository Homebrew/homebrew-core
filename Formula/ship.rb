class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.41.0.tar.gz"
  sha256 "0d2066caa0f378628a3ba1f3d2b7012c4675cc371025be83c8f71b4ff68b14bd"

  bottle do
    cellar :any_skip_relocation
    sha256 "54bfc38eb231c2f8f62df76a054e5df8795505c82c6b71ba63e3ec7377b1b261" => :mojave
    sha256 "1be7e4b29dee288fc2a0f0cbeea1d121eb6e982af202f0dd29f8a9a13135824c" => :high_sierra
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
