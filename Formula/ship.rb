class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.33.0.tar.gz"
  sha256 "04503b36184c45baf6f208c77ddf751ae5785c9bfcd2041ece4d3f73da6b45e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "43628aba5bd273bd56a9d1d9aaa4595aeb7cc17f1950f9e86f1f2bda5762c5b2" => :mojave
    sha256 "8b20f40540db4b97114b552fee15f5f9770d1badbc1047a3430000208eb02d7b" => :high_sierra
    sha256 "fef47bef316800bae6eef241a80af26fdb2f4439159fc0301e134b8d58274759" => :sierra
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
