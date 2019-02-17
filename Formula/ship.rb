class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.33.0.tar.gz"
  sha256 "04503b36184c45baf6f208c77ddf751ae5785c9bfcd2041ece4d3f73da6b45e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8835e7018b52332b817de8eeb3032c6fbea12759940437f7816c39b194b4f78" => :mojave
    sha256 "ec3fc90a826ab0e54628a4d0b7067a7e4bf584b152be7039b42149894b98806c" => :high_sierra
    sha256 "8e8bb0b2d21a1a277812015c4da8f2f52b8a48cf7738e3633f180a55a0479ff7" => :sierra
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
