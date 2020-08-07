class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.54.1.tar.gz"
  sha256 "b5448af60bc278984fddeec5f069ec9a48e64f2100d656c9c18e3b39707218f2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fe2c014d97b6d08c2710e0f11f120a562f31e1dd3e147a74b41c360d1c832c5" => :catalina
    sha256 "08e63b59f92f5ed0661d9a06a0b96112376ea99d561ce5934008e88fce21ac6c" => :mojave
    sha256 "6cb5f8cff9bc46dac11e7042db51aad959b21398764434ac44e5b9d836ccbc86" => :high_sierra
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
