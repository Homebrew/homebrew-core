class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.50.0.tar.gz"
  sha256 "fb022bcef11a5e047355c00a5c726a861ebfad7390c6b84023244e1ae2dbcf4b"

  bottle do
    cellar :any_skip_relocation
    sha256 "164ead75f3411fa485b5acdfd7117e68d4258057964c6124a4458b56ed670cc8" => :mojave
    sha256 "b91f3666eb0b665d1b8713b64adf49584c5d399932164fbb11e91881b82e3ed0" => :high_sierra
    sha256 "8552a6b20f231b39f15ed5d3d49a4535de88ee5eb51084c9e1425e6c60d423e0" => :sierra
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
