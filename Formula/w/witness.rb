class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://github.com/in-toto/witness/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "76c571202fda4a586da857322ec2a0ac8a96659ace455902bbd75e4b62c785ea"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "420e632e0e47a87ab9fa2112b52d81eb1002736f83f4c463a2b45c518c50b72c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "420e632e0e47a87ab9fa2112b52d81eb1002736f83f4c463a2b45c518c50b72c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "420e632e0e47a87ab9fa2112b52d81eb1002736f83f4c463a2b45c518c50b72c"
    sha256 cellar: :any_skip_relocation, sonoma:        "c16fce26157ce86f603e3726fba82e6c5c59d286c6c8f1b4c0d568ed14da5ab1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cb105731d8f0330de7432ecaa415d8cc3dadfa24e5208a551e74fe67b437560"
    sha256 cellar: :any,                 x86_64_linux:  "04d410177686daf7c687dfe42b150de99944d26926bb0c636b2698e9e691e4d9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/in-toto/witness/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"witness", shell_parameter_format: :cobra)
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
