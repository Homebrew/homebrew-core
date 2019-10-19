class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.52.0.tar.gz"
  sha256 "37622f1671947b038b7061341bfadbaa44e16bb9c59748cce57d2a68fb8f0d54"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca6795f483c9b5315deca322b8993c2154f99868ad061a987129783206675a6c" => :catalina
    sha256 "c665aae37628fcf712ebc29c28b056e37aefed195c20417b45ef0871a8206000" => :mojave
    sha256 "68815f321ff3619e9ec3f54898ed6de15239063535e76c3db5effbdceba6969e" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "node@8" => :build
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
