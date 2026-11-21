class StepKmsPlugin < Formula
  desc "Step plugin to manage keys and certificates on cloud KMSs and HSMs"
  homepage "https://smallstep.com"
  url "https://github.com/smallstep/step-kms-plugin/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "4748aeb12f0034f1df1a38999afcf4ad5075b1a7cff173ee9e95f5fabac522d0"
  license "Apache-2.0"

  depends_on "go" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "pcsc-lite"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = %W[
      -X github.com/smallstep/step-kms-plugin/cmd.Version=#{version}
      -X github.com/smallstep/step-kms-plugin/cmd.ReleaseDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"step-kms-plugin", shell_parameter_format: :cobra)
  end

  test do
    assert_match "step-kms-plugin/#{version}", shell_output("#{bin}/step-kms-plugin version")

    # Create an EC P-256 key with the software-backed softkms and export its public key.
    output = shell_output("#{bin}/step-kms-plugin create softkms:#{testpath}/foo.key")
    assert_match "-----BEGIN PUBLIC KEY-----", output
    assert_match "-----BEGIN EC PRIVATE KEY-----", (testpath/"foo.key").read
    assert_equal output, shell_output("#{bin}/step-kms-plugin key softkms:#{testpath}/foo.key")

    # Sign a digest with the softkms key and verify the signature.
    digest = Digest::SHA256.hexdigest("homebrew")
    signature = shell_output("#{bin}/step-kms-plugin sign --verify softkms:#{testpath}/foo.key #{digest}")
    assert_match %r{\A[A-Za-z0-9+/]+=*\Z}, signature
  end
end
