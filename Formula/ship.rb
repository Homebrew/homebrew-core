class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.47.1.tar.gz"
  sha256 "74990c6eb6c83839fcc87a056224ce30aebb84e2cd7ada8a8955c04817729205"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6e4a6ec94811583c3d551159183b7141f4db4569ac54e42c318251e7afa48c3" => :mojave
    sha256 "1645644928a128a065d3fd46846fa7a100d8c20d4207959f40d61d88d05740a8" => :high_sierra
    sha256 "c66459842cbd080fa62124f4dd33120176e279be2bfe1f822f64507f659c2e61" => :sierra
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
