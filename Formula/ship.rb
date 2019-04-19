class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.41.0.tar.gz"
  sha256 "0d2066caa0f378628a3ba1f3d2b7012c4675cc371025be83c8f71b4ff68b14bd"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a5713e858d26e422b0b1faa884e8644cff7d21689c18f58d368e86e03f6b226" => :mojave
    sha256 "df290f68671d175fcf33ffbc91a7c3a2e6cfcca20b1d236b068a1875cb6190cf" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  depends_on :macos => :high_sierra # Ship fails to build with Golang 1.12 on Sierra

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
