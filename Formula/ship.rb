class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.53.0.tar.gz"
  sha256 "da1b0bba9e7431c27ae08774be906c17e278ef4703c288767bbaaedf0cc8d2c5"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b8faedd04cbb5f93cb2ec5f7b405b90e781f186c482c3b7465150f9a4325d56d" => :catalina
    sha256 "d5a840b60911e80e0c656023fc3b5500c86a5828865c156a24329d0d9780b6ff" => :mojave
    sha256 "04085e4e57112651eec2f1bb757f0802af344a04f7b2fdbdb47499ab5a14d874" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    # Needed for `go-bindata-assetfs`, it is downloaded at build time via `go get`
    ENV["GOBIN"] = buildpath/"bin"
    ENV.prepend_path "PATH", ENV["GOBIN"]

    system "make", "VERSION=#{version}", "build-minimal"
    bin.install "bin/ship"
  end

  test do
    assert_match(/#{version}/, shell_output("#{bin}/ship version"))
    assert_match(/Usage:/, shell_output("#{bin}/ship --help"))

    test_chart = "https://github.com/replicatedhq/test-charts/tree/master/plain-k8s"
    system bin/"ship", "init", "--headless", test_chart
  end
end
