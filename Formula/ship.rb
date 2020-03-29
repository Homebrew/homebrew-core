class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.53.0.tar.gz"
  sha256 "da1b0bba9e7431c27ae08774be906c17e278ef4703c288767bbaaedf0cc8d2c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d7b8c8e60710b2e026a1b315355c025822b9faa9c71cae4eb4f955a70f1e492" => :catalina
    sha256 "599f2f2350818a5488b0640862b3a9b269f09e692a3c3a3d2e447972923606ec" => :mojave
    sha256 "cbf46ca0e40da91961e607e739799a6c189ce42a56270d2c262395b520c8f341" => :high_sierra
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
