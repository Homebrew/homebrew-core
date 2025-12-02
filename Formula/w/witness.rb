class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://github.com/in-toto/witness/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "5c4702a0b15380f82c1e421c15582671321c5c0a406093129bcfe288c68693dc"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25cde82fc6d757d7c1fbe61260802d1b190f010f2f49dee717cb52e541a89aab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97c4bc5582063c24500d7af959fb9bf248257c7c95a37304339246231198b252"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d359e467d168a50f63771f5e6f9d059e45b173f05ee88356760d0faa94e6cd8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "93f926c0660d154aa6949728142111e098848fd0566a670719046a57cea0f4e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e215d4e64d94ac2a28724181a3214f7b80ae777639f4cb43da1393ea3bf85bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9e5f7f1f01c8f867e553fa0ea1dea63aca985e33bb5317b51d21147e3520799"
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
