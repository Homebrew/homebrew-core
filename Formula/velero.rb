class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/heptio/velero"
  url "https://github.com/heptio/velero/archive/v1.1.0.tar.gz"
  sha256 "9313f059c9c973052fba4b307e652b1067b8542302277af1f610415e79cb32c0"

  bottle do
    cellar :any_skip_relocation
    sha256 "713560c7ada1422f49cf04e4146e3afa483e5f00b50a67fcc4c7180e7018c394" => :mojave
    sha256 "74e077b085c10713f22c09fdc592ef6dce9e13a6a87a3d83b02ca9f66f1557c1" => :high_sierra
    sha256 "36bce9094dac8e3dd1ed7d108dea0237f90f101ff158ae7279a53907258e5ed0" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/heptio/velero"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "go", "build", "-o", bin/"velero", "-installsuffix", "static",
                   "-ldflags",
                   "-X github.com/heptio/velero/pkg/buildinfo.Version=v#{version}",
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
