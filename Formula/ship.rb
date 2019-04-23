class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.42.0.tar.gz"
  sha256 "675add9889b5ae2bcdf72be7a77e91d268572a40967607abe756bfcfc8607cb5"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6f89b086839d19d642d4c64c19d87be4102b48676c6c3fb1715681597a92edd6" => :mojave
    sha256 "628e57d3faccdfec9e3d1f90b674c60a1df262cd30f8d64ad5881957f694db39" => :high_sierra
    sha256 "7cda06b6ab842d5a163a865f40fe4341ba175a421a00f784a066785bdb660828" => :sierra
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
