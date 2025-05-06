class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://github.com/in-toto/witness/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "af28bd620a90d76933f529ed72655841b04a617cf9abb61ff52fe0edc1fc23d7"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b5936f021ba12991c70aa67d9e43bfcea3ceb818ef3fc54e2838ff813179710"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4808c187ca99c721b7fcfcec59b7acb998af40b6f90ef0ed11e938a304c13568"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "122725c3b78c865e6e0f0bfa7a359f6cc86cf4338ff0f8b04ad50349ac5b2497"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce469b91e24105696a60d9a6c66312077d4d90b54bd783957ab71e1775234d9d"
    sha256 cellar: :any_skip_relocation, ventura:       "c6e0727c4a7cea0f168017986e8cce46d778158a50dce55dcb28131396dbd6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23f5d88458746d2566874da6db9ada7f7eefbb4927b210f160f0bbdee571d903"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/in-toto/witness/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"witness", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witness version")

    system "openssl", "genrsa", "-out", "buildkey.pem", "2048"
    system "openssl", "rsa", "-in", "buildkey.pem", "-outform", "PEM", "-pubout", "-out", "buildpublic.pem"
    system bin/"witness", "run", "-s", "build", "-a", "environment", "-k", "buildkey.pem", "-o",
           "build-attestation.json"

    output = Base64.decode64(JSON.parse((testpath/"build-attestation.json").read)["payload"])
    assert_match "\"type\":\"https://witness.dev/attestations/product/v0.1\",", output
  end
end
