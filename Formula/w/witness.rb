class Witness < Formula
  desc "Automates, normalizes, and verifies software artifact provenance"
  homepage "https://witness.dev"
  url "https://github.com/in-toto/witness/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "352c263752059e6c87e0a3975d9d826642c27778de8134ee1224adf8eaf7d56b"
  license "Apache-2.0"
  head "https://github.com/in-toto/witness.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4fa699c53161cf44ac6317673fa5b37a2ace5f4573f8f134e369f7495f5a5949"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58b5e53ffe55cbc1588bf643429f91809f2a0540a072e41b8747cd99f56edc93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30f96b945e3dde43087d361dc024286ffdbead9972203920c25d0704b96bb237"
    sha256 cellar: :any_skip_relocation, sonoma:         "81d7f42a972255895ed51ebef42a49c58e34d3317c1134e4a5af112404854369"
    sha256 cellar: :any_skip_relocation, ventura:        "8169b9b180b1fdbd853b71d6abc91448407fdfe878835f80cdc92f43ffeed4b1"
    sha256 cellar: :any_skip_relocation, monterey:       "be2ec4b23316811cd69311d4ecba9e5516fe9dbc3c3aa11197550c2587444c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bce8b0607674c19f2b84ca420cd60485a285397ae46be68c29fb1c7eec68e3ec"
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
