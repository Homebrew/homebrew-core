class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.30.0.tar.gz"
  sha256 "12074a1ab8b0520c34dd3778d12d1bce6caee365edcaa85656c32fc80717142f"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c782e56057733e36f5066351b7cefccf03a30113b560de8a28186385badf051" => :mojave
    sha256 "440ed034dff71465c0ef8d2c7f7aad4391e2672fa00bb3736fb4a9c3734ed4a2" => :high_sierra
    sha256 "8c16e2ba902ea22cff0de5c9e68856432f8fab2b2d0a1accb54b0094f66a55a2" => :sierra
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

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
