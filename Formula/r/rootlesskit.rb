class Rootlesskit < Formula
  desc "Linux-native \"fake root\" for implementing rootless containers"
  homepage "https://github.com/rootless-containers/rootlesskit"
  url "https://github.com/rootless-containers/rootlesskit/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "2f934f30bcac3f659fd2662518a28e2e3ab6fa0f3362ba09ccc75ff7d504dc99"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "dfd3e89b1af6efef83af4c1fe4a94966bc22d471a73348e56904399c9ba837c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "30fd508c308723027a78a6be6f905f40efad1ad451983326011103852db822be"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./cmd/rootlesskit"
    system "go", "build", *std_go_args(ldflags:, output: bin/"rootlessctl"), "./cmd/rootlessctl"
    # cmd/rootlesskit-docker-proxy is not installed here, because it has been deprecated
    # since the feature was merged into Docker v28.
    doc.install Dir["docs/*"]
  end

  def caveats
    <<~EOS
      Depending on the kernel configuration, you may need to add the following line to
      /etc/sysctl.d/99-rootless.conf, and run `sysctl -a`:
        kernel.apparmor_restrict_unprivileged_userns = 0
    EOS
  end

  test do
    assert_match "specify --socket or set $ROOTLESSKIT_STATE_DIR", shell_output("#{bin}/rootlessctl info 2>&1", 1)
  end
end
