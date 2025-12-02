class Terrahelp < Formula
  desc "Tool providing extra functionality for Terraform"
  homepage "https://github.com/opencredo/terrahelp"
  url "https://github.com/opencredo/terrahelp/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "bfcffdf06e1db075872a6283d1f1cc6858b8139bf10dd480969b419aa6fc01f7"
  license "Apache-2.0"
  head "https://github.com/opencredo/terrahelp.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0473183fea6fcf7de2d8bb2a2ff65a1230c023e994b2cc1c1bcca147d16c37ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b5fc796c20c29a328691b8499b2987a5249ea4be381ceb270d73200dfd310f85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c077330b4b023abcd41cc69010561ff2046b426a760ea6129ff496df69416b04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0637ab5db3f9423836bd621b67c01fcfbcf44fd86ac6033ff2b4ffab979a64b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1de2d581302493095a12fc646062b1ea074aa792a36e81d37827438e832599a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a416eab4b11b794fd807c6a6ce9d1fd87ebf8a4bfedeaa6ac45eeb9f6c092d52"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b6320e4c3b16729d7b8399435f0b1cd3dc8a84c0391653c54c613fb8395b132"
    sha256 cellar: :any_skip_relocation, ventura:        "87ba308df8d9e75be30aa87e63ed4682fe818f5dffc5d9528325fe6782876971"
    sha256 cellar: :any_skip_relocation, monterey:       "e04b7ade448da1809858ef7cefea05f34b5670d4b159b3f67d8700c0572201d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "da129e3fa2f21f00fe0b054d5510509d39d6d26cbd58efa7d06297363254fcc7"
    sha256 cellar: :any_skip_relocation, catalina:       "8db95e8da4909b68eaa18a9fab2e38769fcfa79426b3c1a53a4ac9d5315092fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ba89b11520800ffb246741ad83c4825f42eb767d6ede1cdcf89897da0d39a9ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fdaed3d9218418ada94b13cbdfc0bd156ac0b5b44294a95674df07a3e66147a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-mod=vendor"
  end

  test do
    tf_vars = testpath/"terraform.tfvars"
    tf_vars.write <<~EOS
      tf_sensitive_key_1         = "sensitive-value-1-AK#%DJGHS*G"
    EOS

    tf_output = testpath/"tf.out"
    tf_output.write <<~EOS
      Refreshing Terraform state in-memory prior to plan...
      The refreshed state will be used to calculate this plan, but
      will not be persisted to local or remote state storage.

      ...

      <= data.template_file.example
          rendered:  "<computed>"
          template:  "..."
          vars.%:    "1"
          vars.msg1: "sensitive-value-1-AK#%DJGHS*G"

      Plan: 0 to add, 0 to change, 0 to destroy.
    EOS

    output = pipe_output("#{bin}/terrahelp mask --tfvars #{tf_vars}", tf_output.read).strip

    assert_match("vars.msg1: \"******\"", output, "expecting sensitive value to be masked")
    refute_match(/sensitive-value-1-AK#%DJGHS\*G/, output, "not expecting sensitive value to be presentt")
  end
end
