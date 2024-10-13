class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://github.com/in-toto/witness/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "b339520c1665de3d5d1efa4a4c4f97cd8f0c3a152ff9ab9abca94e41e4c1924a"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "28b5d385d73647959f52fff65d7577f0aad73018a11029634ea8a6d4876847c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "747f88b6f93a91f6a1e0708183db400083568a3e51e2e673cb145f9eb688c8e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdb367ca20cf86f1ab16b3190751d5aa8c57b38f8a73eed2a4cd49b6756f7410"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a832ec6ec65212bd9789316aa2afd63bff2bb95821d0958cef2530c992696c0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d2afa770333213ceac92b86572f9ba221fc7173df510cda45c3ce77aa7d2458"
    sha256 cellar: :any_skip_relocation, ventura:        "c78bf5c966f6d713b32cc8dd2ada9e06539285af3a8e8d599125ad3c08211f25"
    sha256 cellar: :any_skip_relocation, monterey:       "2514a58f498470c8f65a0901ea30cc6169c44f1cab9436f3e87174999d0877f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2fb63072d2eda046ad0c4491d4140530da592a743502840cd2e8ab47aaac465"
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
