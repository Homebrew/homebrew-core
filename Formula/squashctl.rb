class Squashctl < Formula
  desc "Debugger for microservices"
  homepage "https://squash.solo.io/"
  url "https://github.com/solo-io/squash.git",
      :tag      => "v0.5.6",
      :revision => "8c3d21c6525a6be34f92965209d0a85df06178a0"
  head "https://github.com/solo-io/squash.git"

  depends_on "dep" => :build
  depends_on "go"  => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/solo-io/squash"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "make", "squashctl", "TAGGED_VERSION=v#{version}"

      bin.install "_output/squashctl"

      # Install bash completion
      output = Utils.popen_read("#{bin}/squashctl completion bash")
      (bash_completion/"squashctl").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/squashctl completion zsh")
      (zsh_completion/"_squashctl").write output
    end
  end

  test do
    run_output = shell_output("#{bin}/squashctl --help 2>&1")
    assert_match "Squash requires no arguments. Just run it!", run_output

    version_output = shell_output("#{bin}/squashctl --version 2>&1")
    assert_match "squashctl version #{version}", version_output

    # Expect to fail as squashctl requires access to a Kubernetes environment to work correctly
    status_output = shell_output("#{bin}/squashctl squash status 2>&1", 1)
    assert_match "Error: no Kubernetes context config found; please double check your Kubernetes environment:", status_output
  end
end
