class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.48.1.tar.gz"
  sha256 "850f618d86f82fc8d5388fae2c27f0f8a1e6609a954e5376e7901609bc364047"

  bottle do
    cellar :any_skip_relocation
    sha256 "04aaf880c9865da9bfebe49d7aecfc6bd6128333a3cf6cb90f8f69522a40c74c" => :mojave
    sha256 "ac7eecac869bef34ac893e726185775272928d5c9f0916e235e75f1022025dd2" => :high_sierra
    sha256 "ef877c96533c0e5ae5f4e23184924db08670836fb33eb1be92dc4fa923e0b3ec" => :sierra
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
