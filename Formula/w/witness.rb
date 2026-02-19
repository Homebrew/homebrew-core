class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://github.com/in-toto/witness/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "b9eb19bc078cc83daa6a8f87f57bbfd22252f4935d2b952b5a87bfb62c8629ac"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77abec7a4a4acd61fa8efa44f24c6c73ae10c32542ec2969c388670d574c349b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "776513c93c45e4d935526caf0f7dc50b80e0a74973babce28a68fc3ab0dcf602"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e03d209c04d9278b8562ad0643c91934a7d6e2238f7fd549cc9ab294bf497830"
    sha256 cellar: :any_skip_relocation, sonoma:        "17c59616cedb46ac4e73d098e4e19be3c7b2bf8acae4f13db5455326e5025b59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87427f6fb3bd8d47c33bebf9be42fb480abdae0be6aac684a35f3d2041f7d433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0de296aeff869b5c0a698b436218c987af1ac65c6dd58221b923a61073e023a1"
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
