class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.46.1.tar.gz"
  sha256 "d5888be08bcb5229753b5c34641cd1715111883affacf4deb841d9c9e6b29d28"

  bottle do
    cellar :any_skip_relocation
    sha256 "12a11f79d085b680eb96dee1693a2aece5bfa08c752ae2ca7e5010837d16aeec" => :mojave
    sha256 "5526730439e89d25eeeadd6aa17fe02ee60b4fcbc5dafc60115d02ae18ef2042" => :high_sierra
    sha256 "f62416b63d1d11fd33c397b844b60a5bff5182b30c358a9e9a18d89035a34c3f" => :sierra
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
