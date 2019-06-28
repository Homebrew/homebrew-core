class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.47.3.tar.gz"
  sha256 "30321e3d177758f3fcf71cee08aa33db467da700dae1be4b20c7603adfa3f2b6"

  bottle do
    cellar :any_skip_relocation
    sha256 "6bf046a40b9cf33332da166ba819e25d7c3ab1649cac2be6c1d4afc055bf7422" => :mojave
    sha256 "45535e5873df6b605eec85485d0fa6d85a3d8bf1cc19e8865c68b47bca995bd2" => :high_sierra
    sha256 "0e11b2b96181363d72c9816da4420b88771e7366003ee12f45ff5a17577d0c85" => :sierra
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
