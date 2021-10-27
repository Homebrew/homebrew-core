class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.7.0.tar.gz"
  sha256 "7e8a559911956ee25c3dbdf64fe7adc0ab783795f9a59c7b2eec8534f8e7f4cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9417ea2c7ca850fceba82976b4448edff911a2988ef6ef61d8c26cf7030e5c2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "951a590a2827c7147de721967365c64b0f3c41b3750f674af214ef2d17b1d117"
    sha256 cellar: :any_skip_relocation, monterey:       "e451e937908b66ea9314b03b21cd75b7181e7d5220a4c3c073894a2413b28751"
    sha256 cellar: :any_skip_relocation, big_sur:        "893c0ff0b5fe83162550f8c7daa45f852edd36ec42491e5db804d858bb60a94b"
    sha256 cellar: :any_skip_relocation, catalina:       "d912d7ceaede1a0bf419915e83fb95afce89e23a2b2e308833a17a1909f33ad8"
    sha256 cellar: :any_skip_relocation, mojave:         "cea2ae85961c4ab6e7601847cb1ac8afb441d72f2979a9953b68b98229198496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d4b11a0b8deb77c190b697ef714312d402ffaaf30909ca0abe943c917e68d13"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-installsuffix", "static",
                  "-ldflags",
                  "-s -w -X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}",
                  "./cmd/velero"

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/velero", "completion", "bash")
    (bash_completion/"velero").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/velero", "completion", "zsh")
    (zsh_completion/"_velero").write output
  end

  test do
    output = shell_output("#{bin}/velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end
