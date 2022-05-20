class Ship < Formula
  desc "Reducing the overhead of maintaining 3rd-party applications in Kubernetes"
  homepage "https://www.replicated.com/ship"
  url "https://github.com/replicatedhq/ship/archive/v0.55.0.tar.gz"
  sha256 "39cc74fdd884e49301474acafba74128b1a083bbd7e11e349ab6c5da26be8fef"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b463c20ccb6a500aa706ac5a925b090b72f4c59ddcd1ac9a702366da3273af1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af6a5db56e57811acfa331631f24380ed7c3606c0bb0ab60b74e1f50bdb26c1a"
    sha256 cellar: :any_skip_relocation, monterey:       "b87c88bd0fee9a18e44c8f813113125a94bf55da46ed85ab717ab301a159427f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbf6c3cfa97ee48ea7c8faaac11280c4d078d86f81a5674a8cad07667114b991"
    sha256 cellar: :any_skip_relocation, catalina:       "45a18b612b3039e2a00af84c257041bfd8a5f054057d62981f8364704b0723dc"
    sha256 cellar: :any_skip_relocation, mojave:         "c3974dea38bf106223fc9bccb8c3e2eaff6f8d951a95ddad849a63edc6040578"
  end

  # depends indirectly on python@2 and is superseded by kots
  deprecate! date: "2022-03-25", because: :deprecated_upstream

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build
  # Switch to `node` when ship updates dependency node-sass>=6.0.0
  depends_on "node@14" => :build
  depends_on "yarn" => :build

  def install
    # Needed for `go-bindata-assetfs`, it is downloaded at build time via `go get`
    ENV["GOBIN"] = buildpath/"bin"
    ENV.prepend_path "PATH", ENV["GOBIN"]

    system "make", "VERSION=#{version}", "build-minimal"
    bin.install "bin/ship"
  end

  test do
    assert_match(/#{version}/, shell_output("#{bin}/ship version"))
    assert_match(/Usage:/, shell_output("#{bin}/ship --help"))

    test_chart = "https://github.com/replicatedhq/test-charts/tree/HEAD/plain-k8s"
    system bin/"ship", "init", "--headless", test_chart
  end
end
