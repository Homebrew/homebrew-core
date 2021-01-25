class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.55.0.tar.gz"
  sha256 "39cc74fdd884e49301474acafba74128b1a083bbd7e11e349ab6c5da26be8fef"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "87de3fe44a1b8d881b0cf6be5f74c6261dc8b38deb85e7edb48a0b1ac9d73805" => :big_sur
    sha256 "17b2f10424c9728a9bbc19bef3af5d9fab3b350fa2aa2620fced62056065f651" => :arm64_big_sur
    sha256 "7395a181b4bb2581d17a9a45fd054f5f1c15fe1a43a85f559316aea65e2da66e" => :catalina
    sha256 "740a9cd2f1eef9bf09cb029827f5c4fabbc84dd14ee68babf065f85cceee0f12" => :mojave
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
