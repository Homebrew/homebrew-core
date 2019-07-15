class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.49.0.tar.gz"
  sha256 "8c2516affcea3df8525e3c7c6361191dd065f68337332ecf90150f0f798a406f"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6704868731685a3b7c61ea37f4689f3dd62136a5a8e2ff7017e0461ded6e6eb" => :mojave
    sha256 "a5e13785da153743a42faa16fddce30af147e8849286e3409e0c204e22ae0c9c" => :high_sierra
    sha256 "ac220633ec132a245c5b4521e775b790425126aa71f401764b82b91620c412eb" => :sierra
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
