class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.5.1.tar.gz"
  sha256 "b5d8f50f8f84f08ec7fc72d2572fd15749b3b95f1a0ac2483f3a4fe6f43e4961"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f776808bb0cb0f4e05644ac7ed8818c30d6ce37136fa88ccca223fa7c2db5ad" => :catalina
    sha256 "0d49268aceef9cd0db1f3f6e5f8362175b6d7ac4fb57f8cd7fee2ad4d0b056b2" => :mojave
    sha256 "7dfbd8334fcd79e17ebba1c471ce1c7b5aab73428783782e86b382f9c1f4efaa" => :high_sierra
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
    output = shell_output("#{bin}/velero 2>&1", 1)
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end
