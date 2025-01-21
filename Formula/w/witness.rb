class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://github.com/in-toto/witness/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "dec154b72b2df16cc90df998a508952a6c7c25956a3096213cd6e20576d05e47"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d662cf597161c2590f043fa9f0fd9038493e6ed32135807700a80ecbbb55881"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d662cf597161c2590f043fa9f0fd9038493e6ed32135807700a80ecbbb55881"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d662cf597161c2590f043fa9f0fd9038493e6ed32135807700a80ecbbb55881"
    sha256 cellar: :any_skip_relocation, sonoma:        "af1d846e982518fe0067a855721bf76178baab408f7bc4f58e4a9c981611205e"
    sha256 cellar: :any_skip_relocation, ventura:       "af1d846e982518fe0067a855721bf76178baab408f7bc4f58e4a9c981611205e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30ef26decde8cbd88b46735788ddf538e8e81ebfef6e45331388ed2a9c644834"
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
