class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.32.0.tar.gz"
  sha256 "e0625b143d114b0b6080494ba3cda65c4909997fd44525456d213f62c34429c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "3249e4b2a0a49cf7f02af86119e454c0530e7c55b43d03ef4d9e0d5ee29d0e95" => :mojave
    sha256 "262dfe8c33d2cb23dacd669cd7d702f063ed3f6d0bff37e20aa69cd2a17d9e1a" => :high_sierra
    sha256 "ec3c51979a0c3aca22f13130809c4ff9afbd21b203a89519c750302c63c713e9" => :sierra
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
