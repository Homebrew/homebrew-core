class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.45.0.tar.gz"
  sha256 "c4ea45108c99c429407992c1034182243bc4fe950af2557efcd669289eefcb32"

  bottle do
    cellar :any_skip_relocation
    sha256 "25cd15ea979981eade28f28579c7d38d3e04a7c81121766dc4e485cf816e2362" => :mojave
    sha256 "ebe16ae478b8b3e2ded1ef621e03cdfc28c48e2f8811f24bed751d305b110b3c" => :high_sierra
    sha256 "e76df5f303070ffb481ba8a8a36cdd5629b5ce3142b2b1b05e9eeea89d903f34" => :sierra
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
