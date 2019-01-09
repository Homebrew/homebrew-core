class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.30.0.tar.gz"
  sha256 "12074a1ab8b0520c34dd3778d12d1bce6caee365edcaa85656c32fc80717142f"

  bottle do
    cellar :any_skip_relocation
    sha256 "df9bc67216db29650755f3a2eef51b222f7b8822391316b1d05494ad6bd22251" => :mojave
    sha256 "2c3be7d504b38c573e389f190803efa65d75752ead39d8a25b1d51a1714bb238" => :high_sierra
    sha256 "a9127e24621654a0530fc6fe67aa1ce87ee9cc07dbd05c09bea8a315640c04f5" => :sierra
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
