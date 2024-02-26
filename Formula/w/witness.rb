class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://github.com/in-toto/witness/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "a64f86533dae75a1f8b7e4e54e890b476d2c20b3e12ddd1527b3e3e39ec83e73"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e69f739af76f1c69de2637b09886c0e8d1fb9455cd2a0e3ba21687cb98495e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76247f4e6ef0a0bfac14c4e470b04f698779f7ba5ecff8988c6d8a83132e8b73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b22a17faab7255c37500f46eaed456216af1c890054dec24a54163c4d7beb3e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9ba91a19eb19a69f08dc952ae51822dd4d5300e8b6fc58f316853534397ba1f"
    sha256 cellar: :any_skip_relocation, ventura:        "e0cfd6e5c6932d26e64396758592e19b80daef20e2b889dbd5a6ae264a6885f2"
    sha256 cellar: :any_skip_relocation, monterey:       "15e23b1a0ad375719b82517016ed93174649de9278241e47f6e70c05ae1ceef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e6009218b64571ae312756693a9d3daf8aad663150660e7d1a4d4dfb09922d1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/in-toto/witness/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

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
