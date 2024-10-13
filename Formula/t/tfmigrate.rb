class Tfmigrate < Formula
  desc "Terraform/OpenTofu state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/refs/tags/v0.3.24.tar.gz"
  sha256 "6d84a7199f031dd795ebac899f5625375670708994a42dd71e4f3bc0f570f202"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "090d73c374ab8d96bf471ca71bdd015bab3eb39b59e452cbe15da3749995eed5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73e8f7ee7c9869c2b07e4107ed867e83aa5f46036b9e66485a3c828b6bb847bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5b9cbc5bed9f99139694249d943606edff30de9437a16bf3a3f5d1f7a11f693"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f38c03df2717c63637a9fe9086a4d303b8b188d5da49206fa55d9cd84ec8801f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6a29688276af8be54d7986a1a9349e2cf565bfd96256b0e33ad228e42a4716e"
    sha256 cellar: :any_skip_relocation, ventura:        "3883fc61d9fc854d669d871cd9a14ecd875956d44ff185451d42dbd9ca034d76"
    sha256 cellar: :any_skip_relocation, monterey:       "e1bd199738832d2f36373ef0f2e3c374ecdf91129288310a23ec141ab443243c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c71ee6897542e4564f992e97cb7e6955fc010fe04d319cf0263cf013dd20b07"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["TFMIGRATE_EXEC_PATH"] = "tofu"

    (testpath/"tfmigrate.hcl").write <<~EOS
      migration "state" "brew" {
        actions = [
          "mv aws_security_group.foo aws_security_group.baz",
        ]
      }
    EOS
    output = shell_output(bin/"tfmigrate plan tfmigrate.hcl 2>&1", 1)
    assert_match "[migrator@.] compute a new state", output
    assert_match "No state file was found!", output

    assert_match version.to_s, shell_output(bin/"tfmigrate --version")
  end
end
