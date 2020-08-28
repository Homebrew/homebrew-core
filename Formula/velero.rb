class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.5.0.tar.gz"
  sha256 "b45a7ee894706a941ab27698293bbca6922de927694cd5c135fd78fe0b133a1c"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "43f34e8aa73e955b28de5f571b34515354da24439d4109102844e99e6e03257e" => :catalina
    sha256 "9f475940b9dd4efc10b9a729aea4b7e9fc48115e3cea08ddb7c50eb3587e8298" => :mojave
    sha256 "a77a77035798f2f3155a073850b5eac02e3de413c7273b3e97cb9f1d6d92e8a8" => :high_sierra
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
