class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.55.0.tar.gz"
  sha256 "39cc74fdd884e49301474acafba74128b1a083bbd7e11e349ab6c5da26be8fef"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6b0158bfbccbade0b475b4ebc29f34eaa0cd1987f5a51ff57f621f3fbae7d1f" => :big_sur
    sha256 "b27f8e7eec97b2b507d794752daf9958f0c358643cb7454175a310153c744421" => :arm64_big_sur
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
