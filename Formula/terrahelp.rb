class Terrahelp < Formula
  desc "Tool providing extra functionality for Terraform"
  homepage "https://github.com/opencredo/terrahelp"
  url "https://github.com/opencredo/terrahelp/archive/v0.7.3.tar.gz"
  sha256 "e0d281092e399804e7fcb7636c45af2709e5b69609af07c6b8929ac793afe7d9"
  head "https://github.com/opencredo/terrahelp.git"

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
