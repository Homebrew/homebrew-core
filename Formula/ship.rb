class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.34.0.tar.gz"
  sha256 "252ff2eef0b1fc9289caa037a46dc008d0dd45f893e58d7a6424c8990a447440"

  bottle do
    cellar :any_skip_relocation
    sha256 "92e12ad142087520cf0844a21cdb8392635de6842450ba9958aed506efdd6576" => :mojave
    sha256 "0c96871041a65b4e09ddca7ee167d94b28fce82f6678a290aa5ebcadf2dca2c2" => :high_sierra
    sha256 "ea851b99a03a3b0926ff99cae99eb8c6fa8e17c64861779bb25c713d345df392" => :sierra
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
