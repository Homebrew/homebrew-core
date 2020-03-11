class Terrahelp < Formula
  desc "Tool providing extra functionality for Terraform"
  homepage "https://github.com/opencredo/terrahelp"
  url "https://github.com/opencredo/terrahelp/archive/v0.7.4.tar.gz"
  sha256 "2d70b6471bfb4b9c8ff3bb12050ecedca8d39830fa221bf8c319a1b6144ee6e5"
  head "https://github.com/opencredo/terrahelp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "27b3df54ff8a7eadd2d0eefaae0036da26e0c0c5cdeb917b9b278c1d5346e1c6" => :catalina
    sha256 "9277377d2e0970ff628d0a0bfd8d67d701c588b0357c5b38bca24d70d0b102de" => :mojave
    sha256 "5c44b6ad3f3616681ed6408eb2c28f8e4e2e3e7a81a1694f464ea6507b5a531f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    dir = buildpath/"src/github.com/opencredo/terrahelp"
    dir.install buildpath.children

    cd dir do
      ENV["GOOS"] = "darwin"
      ENV["GOARCH"] = "amd64"

      system "go", "build", "-mod=vendor", "-o", "dist/darwin/amd64/terrahelp"
      bin.install "dist/darwin/amd64/terrahelp"
    end
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

    output = shell_output("cat #{tf_output} \| #{bin}/terrahelp mask --tfvars #{tf_vars}").strip

    assert_match("vars.msg1: \"******\"", output, "expecting sensitive value to be masked")
    assert_not_match(/sensitive\-value\-1\-AK#%DJGHS\*G/, output, "not expecting sensitive value to be presentt")
  end
end
