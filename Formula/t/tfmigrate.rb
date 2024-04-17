class Tfmigrate < Formula
  desc "Terraform/OpenTofu state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/refs/tags/v0.3.22.tar.gz"
  sha256 "4b3b920bd76bdf74dbdfc41e1d36b31bd920505918d041044d7470135d20166c"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "484a25aee9026f0968022c1ab992e879603d9986fd84eab13d2ef9694aa8bf19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c333c5bb3513b57c4c73d278fd2dc8875b29a653831c6bdeec42918eb570e9dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75a3c3b918acef1e3dd8e809799aea183f29ab30eb3b61f1ff4d6647cb715ef0"
    sha256 cellar: :any_skip_relocation, sonoma:         "9516a990cf2d93eda280db592f788da13c5e278053018ff67b92cdd9eeffa4c4"
    sha256 cellar: :any_skip_relocation, ventura:        "446a56e1d43ba20b5328c038fb9f814811a8855bd1b485945eeedf46c23ceffd"
    sha256 cellar: :any_skip_relocation, monterey:       "ac0814f7045c52f71a375700ae8e084b5137c63f31f6635d3a40161d535fe79d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "967a74bf279f6e615b8eeaaedf2a39d6e6337e006b3aeffb3793b0e73c103603"
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
