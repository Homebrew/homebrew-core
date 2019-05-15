class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.43.1.tar.gz"
  sha256 "1b97701c97a3009df4f8d26aa5ec1d2dfa1f8ba73f9c6672a64f75181491a8e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c0ef59b3b353a5237274b9a9987c43a9f5508e0a94f5ee4f9f8f0b9a5b9f25b" => :mojave
    sha256 "56a0b3277ece6d392d44027cbcf1f79fdf346fd9b9331411664131d14893928e" => :high_sierra
    sha256 "9d264eb3e1ae0c33121cc6196176825ac0f2c3b5b1839f6900f8b7519e874f68" => :sierra
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
