class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.48.1.tar.gz"
  sha256 "850f618d86f82fc8d5388fae2c27f0f8a1e6609a954e5376e7901609bc364047"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5beadd6c5c22c4319dc2cecec6118508d328f4a5c9bbc16cbc5a0f64b5dc8e7" => :mojave
    sha256 "a640d9d9969e96d83a0a43241c42e0428d8d369eab549676e4ff94897545bbfb" => :high_sierra
    sha256 "1c076321b418fbf84ad8107f6d832c37908b0d3af61e56861c18d424409766f4" => :sierra
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
