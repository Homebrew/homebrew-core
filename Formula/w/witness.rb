class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://github.com/in-toto/witness/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "4c178ede178d6a7296e60e9b349c5c4158b9ad3bddf17d035c72a6215ac80371"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4645fc8391c77acb98578f88e41b0001d42b44568fc4c07bb1aae4ed03d99f04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77ff8923ccbff7c5b628d7c147b031ff19f955d4bfdc67ca8bf50fa57f25e7a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7e212c1c6484eadb4d0550f66fcd2149b775940989c9217365ba04e1cc6caf5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b7c1abd60c7f8b47b2587c1496b6711aa11bf9949e9eb87e679a2bd97d53dba"
    sha256 cellar: :any_skip_relocation, ventura:       "959c124169ea4f63dfa35df3f3b40d655aeb173114923c1ca101ad58e7d0e245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feeddaf898c3773ca1eb25c2039e0ef50e292fd0fe6dd20e4312f2802da38232"
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
