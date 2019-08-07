class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.50.0.tar.gz"
  sha256 "fb022bcef11a5e047355c00a5c726a861ebfad7390c6b84023244e1ae2dbcf4b"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c818f28a413adce9f2b7c37b8276d2032e8c01e43e26218491ac61132ac16ff" => :mojave
    sha256 "24e0f0d0560bf56227e7346d5ee51d2baa925d14c148719ceba20ee6f12a7d13" => :high_sierra
    sha256 "4ab3c93465debcbe15218d929bd941a42c8cc507d55ea69fcf15fb083e4be78b" => :sierra
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
