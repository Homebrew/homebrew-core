class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.4.0.tar.gz"
  sha256 "0139071f6e69059a0a1d4897f4331b55cb53bda3d29202d099aea03268891c31"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a2da65129f5938807fab21cee5022e931d3f6f2bc790d50409bf33d1b782e518" => :catalina
    sha256 "54dec0c112160c3cec5373d962c9efd21daff7ccb8b77aa887f135c380d079f2" => :mojave
    sha256 "ea9e954f562e89521ccc19e2adc53f028d86eb8f2257044cfed5967b85c24274" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/vmware-tanzu/velero"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "go", "build", "-o", bin/"velero", "-installsuffix", "static",
                   "-ldflags",
                   "-X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}",
                   "./cmd/velero"

      # Install bash completion
      output = Utils.safe_popen_read("#{bin}/velero", "completion", "bash")
      (bash_completion/"velero").write output

      # Install zsh completion
      output = Utils.safe_popen_read("#{bin}/velero", "completion", "zsh")
      (zsh_completion/"_velero").write output

      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end
