class Kfctl < Formula
    desc "kfctl is a CLI for deploying and managing Kubeflow"
    homepage "https://github.com/kubeflow/kfctl"
    url "https://github.com/kubeflow/kfctl.git",
        tag:      "v1.1.0",
        revision: "9a3621e2b2ce6d2baa5c78acccec5028c4e4cbe1"
    sha256 "64fef513c2b648dae771ee07a4f9b63eb0e2faac9b4f6a27a2f7baa7071471f1"
    license "Apache-2.0"
  
    depends_on "go@1.13" => :build
  
    def install
       system "make", "build"
       bin.install "bin/darwin/kfctl"
  
       # Install bash completion
       output = Utils.safe_popen_read("#{bin}/kfctl", "completion", "bash")
       (bash_completion/"kfctl").write output
  
       # Install zsh completion
       output = Utils.safe_popen_read("#{bin}/kfctl", "completion",  "zsh")
       (zsh_completion/"kfctl").write output
    end
  
    test do
      run_output = shell_output("#{bin}/kfctl 2>&1")
      assert_match "A client CLI to create kubeflow applications for specific platforms or 'on-prem'\n to an existing k8s cluster.", run_output
    end
  end 