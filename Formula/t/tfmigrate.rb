class Tfmigrate < Formula
  desc "Terraform/OpenTofu state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "6630aae0d443827e222a0344096e189d05a4b9897afd1b8a9499ba6173d6eb8d"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "65cff3de122db120d4f394b9614d3b944e1fcf872f278924c00b42d0e6ee7fbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef126861e4028b2c48bccb7eb5f72116aebfee30818603940c3ef8fd0916236c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef126861e4028b2c48bccb7eb5f72116aebfee30818603940c3ef8fd0916236c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef126861e4028b2c48bccb7eb5f72116aebfee30818603940c3ef8fd0916236c"
    sha256 cellar: :any_skip_relocation, sonoma:        "301aa0212bce66744d414925cc73a8a97ea4905f59a030d357d05ea196ccccc2"
    sha256 cellar: :any_skip_relocation, ventura:       "301aa0212bce66744d414925cc73a8a97ea4905f59a030d357d05ea196ccccc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0990baac6fff9aecc7b64730009c0588d922c2e3e9fbade883e88e56e6dec9a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd6c636409a4b4dee3a857647e8ed769accc7a2848fe22a70954603052ab94cb"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
    assert_match "No state file was found!", output

    assert_match version.to_s, shell_output("#{bin}/tfmigrate --version")
  end
end
