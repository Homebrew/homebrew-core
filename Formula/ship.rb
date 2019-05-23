class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.44.0.tar.gz"
  sha256 "40ee3eaab3a43163631d43db24c54c89861f135268c9748f2300e95b852bea53"

  bottle do
    cellar :any_skip_relocation
    sha256 "e82d45b51579809cf98f2cd9a1fe577fba923d734fa355e208f45759cb15f03f" => :mojave
    sha256 "9deebf44a0c5b5a8bc30813d47e51aa1a82de7679ebde867596e213e2e78a80b" => :high_sierra
    sha256 "12861a0f733d3b36b7a52fa5c97d2f0cde321de2210ecac434af743793d7e601" => :sierra
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
