class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/heptio/velero"
  url "https://github.com/heptio/velero/archive/v0.11.0.tar.gz"
  sha256 "366f4c1ed5800dbdddefa60ed88bdd82b406b69b76a214b1d7108997a2f973ac"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "bf306dd8b4823d6650dfe27f08f1c5b78c24d306bfbb4629f5df3f0933336ad6" => :mojave
    sha256 "642258fee6c8f83019c7fe9ce9d1b87b99c4e5dd8401a6fbb1554725ab74dcaa" => :high_sierra
    sha256 "4b93e561d1f5d20a5e3d64d8c1c9c9d314098c0969e62fd42e74595e46ce4929" => :sierra
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
