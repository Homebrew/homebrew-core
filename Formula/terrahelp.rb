class Terrahelp < Formula
  desc "Tool providing extra functionality for Terraform"
  homepage "https://github.com/opencredo/terrahelp"
  url "https://github.com/opencredo/terrahelp/archive/v0.7.4.tar.gz"
  sha256 "2d70b6471bfb4b9c8ff3bb12050ecedca8d39830fa221bf8c319a1b6144ee6e5"
  head "https://github.com/opencredo/terrahelp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "515040f845a9eb85328f110610d2bc31837771c79828c6979eeddb5c885aac8b" => :catalina
    sha256 "f195506118d3fca9b4b0555e9aef67c4e831053a943fade0580793aa5e89139a" => :mojave
    sha256 "df53d2e287ce9b9b31facff22d50b4181704045e9611ebfb363461025cf1eb8f" => :high_sierra
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
