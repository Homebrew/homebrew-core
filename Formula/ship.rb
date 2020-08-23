class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.54.1.tar.gz"
  sha256 "b5448af60bc278984fddeec5f069ec9a48e64f2100d656c9c18e3b39707218f2"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4dd63ad1bc12b9e1d359d763ea4e4e51ef93a0b3a0c711fd897e7c53ec6642b3" => :catalina
    sha256 "883a7b5236bfafaf23b748218b09ae75ac9d1420c0c5e0cd2ba9ffb6a3c2cef0" => :mojave
    sha256 "f6069bab80cc5dde1e19b353ed41faf449f299a5cf97f61aac8ea3a76cc4b22f" => :high_sierra
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
