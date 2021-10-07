class Tfupdate < Formula
  desc "Update version constraints in your Terraform configurations"
  homepage "https://github.com/minamijoyo/tfupdate"
  url "https://github.com/minamijoyo/tfupdate/archive/v0.6.1.tar.gz"
  sha256 "489ef697be6e203872518c7e711299885762595920ff3b0e7c09e800c8392de9"
  license "MIT"
  head "https://github.com/minamijoyo/tfupdate.git", branch: "master"

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write <<~EOS
      provider "aws" {
        version = "2.39.0"
      }
    EOS

    system bin/"tfupdate", "provider", "aws", "-v", "2.40.0", testpath/"provider.tf"
    assert_match "2.40.0", File.read(testpath/"provider.tf")

    # list the most recent 5 releases
    assert_match Formula["terraform"].version.to_s, shell_output(bin/"tfupdate release list -n 5 hashicorp/terraform")

    assert_match version.to_s, shell_output(bin/"tfupdate --version")
  end
end
