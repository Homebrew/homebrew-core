class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://github.com/in-toto/witness/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "4fd6f510b3b9b9267141760bc1e7c35b733245582def00cc5111d91de05fd97a"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59ec48fd9bf430016febd09e496b7813fbee8fca3927dc9d79fb4450f50dbe7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43b859cf535eee62f70cb3c6133c823d28087ff506f8d7d8efd05d082123ba5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "965d4c3501fd48fba050019dafc65bffbb0313fc76a65cac2bea2c9453327db3"
    sha256 cellar: :any_skip_relocation, sonoma:         "230ddf216c5e1ff5103a5cd7af35c06356f0176d6fdc20bfa1b98c816e3ae8c4"
    sha256 cellar: :any_skip_relocation, ventura:        "f7a3bd1368921a2f189f07e899fe1ab505dfaaffc6a00197636240269aefd14f"
    sha256 cellar: :any_skip_relocation, monterey:       "9ecbc9f00dd8ccec32cc600e6791dd289464ba9de3aee170466d4c76980748bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86fa375a82239eb7d3a97d3d80f7ecf83262ff82d997cd38e2e50d0ae7b65a4b"
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
