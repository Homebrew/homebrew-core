class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://github.com/in-toto/witness/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "382faf0e052a7f1ca3aebf03ba22ae1e70f53abbe3d23cc40071196999e900b6"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f73b29896a0dfc7643e8c5d54364efee8cfd3c8e9eda25f0b066a39f302735a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65e00a91455045ba43b697dfdd4499f943a48cc8390344776c03c41adea135af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96c39c8742d9e77888d2a41b6a893f484739c2e4d257b35f377a3b3ce4e86cb2"
    sha256 cellar: :any_skip_relocation, sonoma:        "11eb05947c21fe2c1298082766c86d3ec499f94da99dfb591614b312920cd6ea"
    sha256 cellar: :any_skip_relocation, ventura:       "33afa9378729dd308db1b09aeb65adb1d56be5f7c25b2f1dd37fe8954701832a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3088af430f4bf0d28549758d03dd967fc9e7f9680a117ee832f86d128d80213"
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
