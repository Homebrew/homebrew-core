class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.53.0.tar.gz"
  sha256 "da1b0bba9e7431c27ae08774be906c17e278ef4703c288767bbaaedf0cc8d2c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba825cf549364ca482c8eef8121fdb3bfd8daef2c62af6dc143d7a2c87ed8c4d" => :catalina
    sha256 "81ed6e65806188a66840a9bc8dc4181cc7be8c250ce0aad701d9e4f8090382a8" => :mojave
    sha256 "5f5c45fb4dcf35d1b5b1d8dbcf37dbbe3d9a1cd50b723b56df65288d007ab65d" => :high_sierra
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
