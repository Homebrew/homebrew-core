class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.51.3.tar.gz"
  sha256 "8ced5155af6a766114272b180f4ac98d2361dd983fe7305dc75c632ac68ea692"

  bottle do
    cellar :any_skip_relocation
    sha256 "df23459500dc4964d54178c7dfe75e63eed276801d5da7e74df451312437c43c" => :mojave
    sha256 "67166806333260851bbdbd7c80a7f79a39c6f20f037bebdc2f862bcd7a4f63f4" => :high_sierra
    sha256 "38631c44561313f452d55ece5e624b0133e233fa3abae86ee3ee730d7b052d05" => :sierra
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
