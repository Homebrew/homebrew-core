class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.47.0.tar.gz"
  sha256 "675ef3e27c1f0e4c4fee691e54508020427526f9b3c22fb09af8bb32c815ab2f"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4ce6d96198ee00313dfed515085f50a8f51388418305170affb1191d5bffbdb" => :mojave
    sha256 "57e6e5c02ba67a464c8cab86e56ff79268533362e3352e1184c6320965eb75c4" => :high_sierra
    sha256 "54e202ce3da3b948476c421839785c8ef689180bb89304ab277b71f597180906" => :sierra
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
