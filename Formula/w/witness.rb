class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://github.com/in-toto/witness/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "997800a7c749b4aa0dd0a64005d0995a4083388e0a6f96483ac687cc08d030e8"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e8c2d7803f8d97b43f0f255c85cccbfd86ee27b277b1372cc1d4934d00737c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d333364e7380f42bdf1e4642500136256dc8a052f91ebe1627e0b0a62fe3e3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b91f90128da755b9ca9b9e05c055cdcb6a7698376f430dc571c1a91468ac61b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a88d2cc9eff2e6eab5e47c75bd934617f5c4bbe34395324c7a68cae6b557fc4"
    sha256 cellar: :any_skip_relocation, ventura:        "876cc18f0d43a34e76897086971752a54d0c41a61dea945d1e616e41a6a72ea2"
    sha256 cellar: :any_skip_relocation, monterey:       "f1708d9033ca718eb392090bb05898334e28ea8cd5b877015f608deed420f200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5795a9cb1e8d73b58e4525838e8ba286ed1a8954d03a4927674c5f97903a3d0"
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
    system "#{bin}/witness", "run", "-s", "build", "-a", "environment", "-k", "buildkey.pem", "-o",
           "build-attestation.json"

    output = Base64.decode64(JSON.parse((testpath/"build-attestation.json").read)["payload"])
    assert_match "\"type\":\"https://witness.dev/attestations/product/v0.1\",", output
  end
end
