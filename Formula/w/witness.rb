class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://github.com/in-toto/witness/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "0b409cd6b01e89be7a9990917e7fb8a6c7557253c7d077fb48796e2d43c10319"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbba58ba1cbfd2492e53c6ebe51e7568944b0de8563f49c47fb717bbbe4c80d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbba58ba1cbfd2492e53c6ebe51e7568944b0de8563f49c47fb717bbbe4c80d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbba58ba1cbfd2492e53c6ebe51e7568944b0de8563f49c47fb717bbbe4c80d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "b88ef34df878542baa82ae66990425ba5607a1d6e65641f5f2fd7fb79c1e54ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "780e5f4ef9774fa4a0b45ab4189a0006e8891edbc4d56088d948dd1aac71f225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62ac10ea094313c2b4f611ce2569f32f95e593b79ff0d3860758ab4acb49c6bf"
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
