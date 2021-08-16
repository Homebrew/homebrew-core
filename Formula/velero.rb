class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.6.3.tar.gz"
  sha256 "06846a5c4e3dd5dd9a44aa6fd2f61674b375ac101bf7e1e1b80b957095258398"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a716a9ba7f366167caa05ae41d4155f8c15152ca2655c0ec6d557fbb4b35a05f"
    sha256 cellar: :any_skip_relocation, big_sur:       "414e6ddcb5d63126e01e33d6059d2e4db441e657dafc618d0c226fa6ca990056"
    sha256 cellar: :any_skip_relocation, catalina:      "2e70e812e6aeb4ca0936c89a71221f59e20488643c9ba61a57ef05696fe97488"
    sha256 cellar: :any_skip_relocation, mojave:        "0a6d6bc432ad242d605fcaa84d99aace7eefbbf7d2e1dc02e6e8aa063737960b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6736ffa4deedc27edd87f68416e99580cce02c86107492051656bbc18332e4f0"
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
