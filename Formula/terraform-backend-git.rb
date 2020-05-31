class TerraformBackendGit < Formula
  desc "HTTP Backend that uses Git repository as storage"
  homepage "https://github.com/plumber-cd/terraform-backend-git"
  url "https://github.com/plumber-cd/terraform-backend-git/archive/v0.0.14.tar.gz"
  sha256 "559920006d870b904e4ef5982e40d75452e6a74082bea206274202c2ab5d0da9"

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.Version=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terraform-backend-git version")
    tf = testpath/"tf.tf"
    tf.write <<~EOS
      resource "null_resource" "fixture" {}
    EOS
    hcl = testpath/"terraform-backend-git.hcl"
    hcl.write <<~EOS
      git.repository = "git@github.com:foo/bar.git"
      git.state = "state.json"
    EOS
    msg = "Error refreshing state: Failed to get state: " \
          "GET http://localhost:6061/?type=git&repository=git@github.com:foo/bar.git&ref=master&state=state.json " \
          "giving up after 3 attempts"
    assert_match msg, pipe_output("#{bin}/terraform-backend-git git terraform init 2>&1", 1)
  end
end
