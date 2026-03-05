class RolesanywhereCredentialHelper < Formula
  desc "Manages getting temporary security credentials from IAM Roles Anywhere"
  homepage "https://github.com/aws/rolesanywhere-credential-helper"
  url "https://github.com/aws/rolesanywhere-credential-helper/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "72426ea946ee5d9b3373694f297f682e0fcea4a7a2b621b38745ad4a846a2fbb"
  license "Apache-2.0"
  head "https://github.com/aws/rolesanywhere-credential-helper.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbb006a85644c33bb9879c3a1ac9d3724e8b403ca6c4c85e3be5e8a631a03557"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c34f9e701dbcca9dd97d5d272f3de216e583d0ca5777210799b079f7a0cfb687"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5858e31d710e764e7e39fe6852516eca58a2803bc744e5ead0ef26116dbd106f"
    sha256 cellar: :any_skip_relocation, sonoma:        "37074db148a53769a7df6587ed9147ac6d5a285313f917e10cbe2e47b5353b9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "487f876518b5e4f2c528a5e67454a1d73e4701fd456cb6ad95e051572c7c924a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee7f67ecbb8ee1de18e43cbbdc5d084028cceeb642251455c1364f4f99d67ca5"
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
