class Rootlesskit < Formula
  desc "Linux-native \"fake root\" for implementing rootless containers"
  homepage "https://github.com/rootless-containers/rootlesskit"
  url "https://github.com/rootless-containers/rootlesskit/archive/refs/tags/v2.3.6.tar.gz"
  sha256 "b491ae9a444f5f4cb925913dfa12ad7a2bcd8aa149114df7afb2fa921359b6e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "8f0ab7ce1faaaa56061faa92db5906afcdb4826ec098d7a2f112f56eabb664f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a72021b4a7cc7003b5f3f282c6d826ef85bb3920023d71a8432720b658ef9c53"
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
