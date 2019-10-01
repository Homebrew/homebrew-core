class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.51.4.tar.gz"
  sha256 "f4cd5e371457858b76e6408466ff3c77805defdfe19fbd988dc4d14d1eae17f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "72282d39f3c1f86ded8529b029ea70743c6039ff125de0d184ecd0ce553d2c39" => :catalina
    sha256 "3fd89e2cb6f036254f7aca3760fdaa6fbf38ac9b9fdc0b02b1e5f968786317e4" => :mojave
    sha256 "7463ca09a5fa07beedcff76d95e4d8dc43417d18bdda6c2ed96970e4c41c62b8" => :high_sierra
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
