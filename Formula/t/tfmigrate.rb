class Tfmigrate < Formula
  desc "Terraform state migration tool for GitOps"
  homepage "https://github.com/minamijoyo/tfmigrate"
  url "https://github.com/minamijoyo/tfmigrate/archive/v0.3.18.tar.gz"
  sha256 "d85ae2601380d35a3d9bacea8dd000635fac18ddd16cd4607359d75dd3adbc7b"
  license "MIT"
  head "https://github.com/minamijoyo/tfmigrate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8bdcb65299f74428c65e7f2f3da96a4453d0f4728dc92f22fe02a7d0b2497aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8bdcb65299f74428c65e7f2f3da96a4453d0f4728dc92f22fe02a7d0b2497aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8bdcb65299f74428c65e7f2f3da96a4453d0f4728dc92f22fe02a7d0b2497aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "5957f3426f5dba6c7129a8ef37e6b8c4bb73e2dcdcc3cda7e0c379480d6b9d93"
    sha256 cellar: :any_skip_relocation, ventura:        "5957f3426f5dba6c7129a8ef37e6b8c4bb73e2dcdcc3cda7e0c379480d6b9d93"
    sha256 cellar: :any_skip_relocation, monterey:       "5957f3426f5dba6c7129a8ef37e6b8c4bb73e2dcdcc3cda7e0c379480d6b9d93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec37c26b708b0b3bef8e758838e6ad01e099f9f7553b281acf482d08c7a18331"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
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
