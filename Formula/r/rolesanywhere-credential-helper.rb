class RolesanywhereCredentialHelper < Formula
  desc "Manages getting temporary security credentials from IAM Roles Anywhere"
  homepage "https://github.com/aws/rolesanywhere-credential-helper"
  url "https://github.com/aws/rolesanywhere-credential-helper/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "5c1da00713ee99e798b99364d759b31fedd7c462d2625d0c8d200a7570d226bb"
  license "Apache-2.0"
  head "https://github.com/aws/rolesanywhere-credential-helper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ab3df37a77081df79ccf6f50b70715d4e86f5fa7d506251b2bc26dbb4730b7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc8666ef27162388b45661c89aeacd2b94c2dde3be158708f96cde86f59d3e7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e17cac634a8d4710e1b50f55cd0ec2ad63d682b2371470288e6df44ffd2e71be"
    sha256 cellar: :any_skip_relocation, sonoma:        "960718e867d13839e916897df6a2060fba8a4c8f5d353506c7c6219c9be624ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14f0b2da30c4910f11289eb2b69a969dd91bce751f314890d0e6fb2da25a6bc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f893504991b4c1a3b5eb45b9a0853b00afb92a0c5fc0a4113a31f6c122d7ffd"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X github.com/aws/rolesanywhere-credential-helper/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"aws_signing_helper")

    generate_completions_from_executable(bin/"aws_signing_helper", shell_parameter_format: :cobra)
  end

  test do
    # Testing real functionality requires a complete setup of AWS account and much
    # more configuration.
    (testpath/"cert.pem").write <<~CERT
      -----BEGIN CERTIFICATE-----
      MIIE/zCCAuegAwIBAgIUWnMzjNagfF7z9opuIl6h4wCv4GIwDQYJKoZIhvcNAQEL
      BQAwDzENMAsGA1UEAwwEVEVTVDAeFw0yNTEwMDcxNTM2MzJaFw0zNTEwMDUxNTM2
      MzJaMA8xDTALBgNVBAMMBFRFU1QwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIK
      AoICAQCtaWxvgFyT0SfhEAy6K/yJOSitfGci89XphbuTFnCIoqRo/qD8K+ZbaFM6
      zRL7zCL0UMlJingi7MVERox/yufTH0najVhKBM30736N6wzWzUuA4vQmaExOwbLe
      ExgOeoSufS+h5WeUZAm03z3RRzmQwIpaxx7aZwkP40o5v+I795RaQle145jNdzAD
      pzFwn1iBCemVOMfBqRn73mH77n/ujQghol03Hroy3Va4P6qoV35+hUr89zUMyBYS
      r4Hrpp0YHVh3cJ+uUrCoTrpNYZ5ykCdPLw8LT1ZF5eruhIVDnlRM4n+zdR11+qb8
      1o7aUr0UIiKe9O6FULnN6GBcWwp8JrCQtllw8tiG2XFfNTkU8ASg2jL0Laauu/Vq
      lsHuTIKwGI4mVbFYW7REWdB7aoVLhn1nT66hko6YV02XugW3KCRomDaqtZXIDTPA
      cFShtRNpjxmDrSuysm3U8jtrIGJoWc1jl93mawAoZaIn+c12+nuXvPyuI4CEP5mp
      Xuj5WhAtkX7GqqKaBmJKsgbAeicRB5MHyMHlS3AVAUYzClxFzlvmk6pdhDlb8eQw
      Ul++rCFliCtzAPJfarZ9iqhjXMVIqIukMQmBpvSpk0IUOswkhyWS7gFQOzSDDDfc
      1KmNrpOhyhYfFM+mVqv4GOpNw0epctuN2XleIFbuHdocKenwLwIDAQABo1MwUTAd
      BgNVHQ4EFgQUP/1BBPiRUBA2gTbKqqm8sMVAR2EwHwYDVR0jBBgwFoAUP/1BBPiR
      UBA2gTbKqqm8sMVAR2EwDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOC
      AgEASQf6WaIGnR+Tlx4Vq7woxGUS5oZggqeRait8R9bk5Y6zR6WeuuVV7Wa8DiaN
      ix+wSZbSYj78oFmJIIFq08syWGorWrffMQ/KegRFaYIjY6v0DZk4eJS9Eyy32m2o
      Gh8LhfICXDV3JbP+6UcjNiROrfvAfirT3s57TVDiK+zEItYA4WHITmezUy5l4RMB
      WMCYp3ie4FjSCgVk1Q0yqIS6dCHR1bj1WnMuSv+V6rRA6chcavxar7jEcnBy6uu5
      NJRWjS/FOZdbyxfNWKMauctUBg2E3z0oDPcJBMDl0il54J6E1rU0pnKDAqcs6BxJ
      qMDFLYsexcglk9ISmEzf3YHaV39ukb+eX0LogTYXi9Mh/FUj30Pd4Z398Ihogm4t
      FNR+ur24BoT5wl79Js3oN8fekT4ULwfGg+lcAOi1IiRH9yJqHlGOpgu+kBeg43qe
      svK9bpMddqY6Q6ryHPQAc+P6bLKs5yfx3cItjqhHhVq8cVqEOoZhhtQ38anklLct
      ePEWPXvZFeufOEoOkQwySYiUQhXlcCveJmNHBkvNIotYH5h6fuX2HvJfBfnvqkkM
      dIpUtT+Di4Gjzk8GNAmISGmlayogyMyHOQR03xRPu2DU6gMpOiLo0isIQvpHdhdq
      g0HKj0SpvXaT/uTqr+B4tG1KDO76d/okqxtYzPGvlUhEysA=
      -----END CERTIFICATE-----
    CERT

    read_cert_output = shell_output("#{bin}/aws_signing_helper read-certificate-data --certificate cert.pem 2>&1")
    assert_match '"serialNumber":"516378245723378548683302024520857503286885867618"', read_cert_output

    assert_match version.to_s, shell_output("#{bin}/aws_signing_helper version 2>&1")
  end
end
