class Tfmigrate < Formula
  desc "Terraform/OpenTofu state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "877b778ef2512a24623c3b96b00c883378b281bbcb2db6f2d106463883f9a145"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fcdf0d825c18afec4c69ee35b9eb3c703bb94fa42f330ebf1f918d154bd6eedd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fcdf0d825c18afec4c69ee35b9eb3c703bb94fa42f330ebf1f918d154bd6eedd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fcdf0d825c18afec4c69ee35b9eb3c703bb94fa42f330ebf1f918d154bd6eedd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a6124225b046f4f93b341eed5dbd25e75046f8191cd69d9d20838bd407d54c8c"
    sha256 cellar: :any,                 x86_64_linux:      "e4f8c139e611603338636066dc8c63ab5169c835c15ccbebb12efcf92f38a5b1"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    ENV["TFMIGRATE_EXEC_PATH"] = "tofu"

    (testpath/"tfmigrate.hcl").write <<~HCL
      migration "state" "brew" {
        actions = [
          "mv aws_security_group.foo aws_security_group.baz",
        ]
      }
    HCL
    output = shell_output("#{bin}/tfmigrate plan tfmigrate.hcl 2>&1", 1)
    assert_match "[migrator@.] compute a new state", output
    assert_match "No state file was found", output

    assert_match version.to_s, shell_output("#{bin}/tfmigrate --version")
  end
end
