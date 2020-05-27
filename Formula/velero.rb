class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.4.0.tar.gz"
  sha256 "0139071f6e69059a0a1d4897f4331b55cb53bda3d29202d099aea03268891c31"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1af83293cc86379b0e1b636b60471a5526903ba0d39f95926025b31d88d3f88" => :catalina
    sha256 "0f6029061d476cf08155316302720e67c2314db9308af9224b5008b9a11e91bd" => :mojave
    sha256 "97aaf6c788952789041bf1745870eeffd1050f5af21079fd76917616281714a3" => :high_sierra
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
      output = Utils.popen_read("#{bin}/velero completion bash")
      (bash_completion/"velero").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/velero completion zsh")
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
