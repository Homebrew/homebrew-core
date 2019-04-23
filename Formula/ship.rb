class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.42.0.tar.gz"
  sha256 "675add9889b5ae2bcdf72be7a77e91d268572a40967607abe756bfcfc8607cb5"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3671484f5cc01009d1b994cdda6ba9d5183f2c8443097f0053b1aba1fa6a995" => :mojave
    sha256 "bf18d28d2a0449f05322218befabd6b0885e81b6b2ade3521170b20936f4f3d4" => :high_sierra
    sha256 "ed1f44931d9eeb3582f78cd9eb7611286ebb5e8d4ad5de048dd49b0d02d81dbc" => :sierra
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
