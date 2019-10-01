class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.51.3.tar.gz"
  sha256 "8ced5155af6a766114272b180f4ac98d2361dd983fe7305dc75c632ac68ea692"

  bottle do
    cellar :any_skip_relocation
    sha256 "72282d39f3c1f86ded8529b029ea70743c6039ff125de0d184ecd0ce553d2c39" => :catalina
    sha256 "3fd89e2cb6f036254f7aca3760fdaa6fbf38ac9b9fdc0b02b1e5f968786317e4" => :mojave
    sha256 "7463ca09a5fa07beedcff76d95e4d8dc43417d18bdda6c2ed96970e4c41c62b8" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "node@8" => :build
  depends_on "yarn" => :build

  # Should be removed in the next release of v0.51.3
  patch do
    url "https://github.com/replicatedhq/ship/pull/1073.diff?full_index=1"
    sha256 "ba2409ea94093529f6c94ff7ae1d377ae209f195a14aa07eccf42164e33f5d37"
  end

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
