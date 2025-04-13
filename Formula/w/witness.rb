class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://github.com/in-toto/witness/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "084f3cde58a9a2b6764f788a18e2505934ad21081e02b0f0eb5d47647f9769ab"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "136aad83521cf0d59e9f3bb9d0e5793e7a14aacb10af8e6055a7cad7fac46939"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "136aad83521cf0d59e9f3bb9d0e5793e7a14aacb10af8e6055a7cad7fac46939"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "136aad83521cf0d59e9f3bb9d0e5793e7a14aacb10af8e6055a7cad7fac46939"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dadbe2aa755ced0717cee1b395bec45f12015f580ef23d413c4c62b8306ebf7"
    sha256 cellar: :any_skip_relocation, ventura:       "0dadbe2aa755ced0717cee1b395bec45f12015f580ef23d413c4c62b8306ebf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "042740e13d94b54f32f87630b32f0e7176843d7a9ffbde04cfb18fb463920839"
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
