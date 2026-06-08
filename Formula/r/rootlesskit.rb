class Rootlesskit < Formula
  desc "Linux-native \"fake root\" for implementing rootless containers"
  homepage "https://github.com/rootless-containers/rootlesskit"
  url "https://github.com/rootless-containers/rootlesskit/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "6d70d1be48fabe0e2b6e24eb1532b4de8d7689374eaf178a67d54d675c10c22b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "db234340c95f0ca968ac87679afa3d0ce4bfe5688ee33b58101da67480f5fc3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ef58c07911b767a74e3941deb8505ec9c43d859fba21278e7f980bd93f7fceb7"
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
