class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.37.0.tar.gz"
  sha256 "920251d304f07b1144b22201573d8b282a91d02c8d69db402125fa695e726bb8"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbff7849f036436922400666d9020b8192ced7b9f6cb88415ad2747a1249bc08" => :mojave
    sha256 "66ddf682687b1e21f04b468b68cf3ad6a050469aa7e6dab6bb5d8785cd0f3ee1" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  depends_on :macos => :high_sierra # Ship fails to build with Golang 1.12 on Sierra

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
