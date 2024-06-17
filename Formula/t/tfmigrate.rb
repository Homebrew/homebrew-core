class Tfmigrate < Formula
  desc "Terraform/OpenTofu state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/refs/tags/v0.3.23.tar.gz"
  sha256 "6141e63dee8aa0c17750eeec0e5a15555ded459d0ceab0926ae3325b07806268"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7427999a92b5131392a753b74af061537da5d13c2e8f572a023fb691fa0aa0e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4667ce46d564606cb177d8c474b45b6dbb2e85d92c908d0b76e78730ef4e2353"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e4b4ac931c1654e798dea4519997a6818652619901c66632324b66314179926"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3f049db73f68ef9e6c6f69d6477cfc8c1fca73e45f3564e8a8f9c7b5455df0b"
    sha256 cellar: :any_skip_relocation, ventura:        "c1abb7306ab26624db7ee3dbf33ee37d945e91236bc06a590d875f2305c6ce9c"
    sha256 cellar: :any_skip_relocation, monterey:       "bc2828363062ce78de8a6e0676bf0f191375818931311c225c11c51da3af5b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5621f0d2ceed5919d7dfa48cd8c4acbfc105147a21fa545c831e82b3ba89bb2"
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
