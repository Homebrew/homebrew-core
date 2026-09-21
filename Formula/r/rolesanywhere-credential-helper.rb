class RolesanywhereCredentialHelper < Formula
  desc "Manages getting temporary security credentials from IAM Roles Anywhere"
  homepage "https://github.com/aws/rolesanywhere-credential-helper"
  url "https://github.com/aws/rolesanywhere-credential-helper/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "34a6f7daa860cb24d6c38b0cc25c228071b2ff0e2526348f193c18c3ceb6d948"
  license "Apache-2.0"
  head "https://github.com/aws/rolesanywhere-credential-helper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6222beadeaf0bbbd0af26f2f1f57cc74f02bc35145c0c477b6b8b049a4db2594"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "008bb81b25cc0cf4323be5b608e75dad5c75cdd24b4492d59f4508761f1fb06f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "12fbf5a5447f67ccb2b31d3ffc90ab38104111d6e4c95893480e2000d02c1f54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1f7f5089a3100c0967438ea9f2cf93cb95abe39b3c6a2eee25d054e94b2ce2d7"
    sha256 cellar: :any_skip_relocation, sonoma:            "2676e59785989ca3eb5380b4e526b9ed99e6c1a4f27621f78aded611778f3c85"
    sha256 cellar: :any,                 arm64_linux:       "211db6f18b00932c75f8bec0282f53c7e2c8a1b6ec8fdbd4bc658ef5165b4d43"
    sha256 cellar: :any,                 x86_64_linux:      "3dc2cf95f51d8b3c199f7312420846b23a8e23b33e6cfdfd78b51a2a243e2619"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-X github.com/aws/rolesanywhere-credential-helper/cmd.Version=#{version}"
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
