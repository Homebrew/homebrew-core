class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.43.1.tar.gz"
  sha256 "1b97701c97a3009df4f8d26aa5ec1d2dfa1f8ba73f9c6672a64f75181491a8e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b45fb3ea81811285ec9e356c958fc78e0c1aefad0d86fb3b82faec986743fe1" => :mojave
    sha256 "06b68058b08a534af9194a0964961f7cce77ddb645877d22d103e3cd8d9d449d" => :high_sierra
    sha256 "9cf24478e0f1dba7b2e2644269ab01d04d0b2c66626c4427ab0aa51a28a48960" => :sierra
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
