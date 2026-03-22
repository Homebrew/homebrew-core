class TfstateLookup < Formula
  desc "Lookup resource attributes in tfstate"
  homepage "https://github.com/fujiwara/tfstate-lookup"
  url "https://github.com/fujiwara/tfstate-lookup/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "b54eee854032983e9c608825810bb12674fb0df077c3dc3618cb16d63b00a3e2"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4fb5fb7c040d736a31656a2d8a5f162f33cd9f6542f8c6cd7e6260a5e1aae13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4fb5fb7c040d736a31656a2d8a5f162f33cd9f6542f8c6cd7e6260a5e1aae13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4fb5fb7c040d736a31656a2d8a5f162f33cd9f6542f8c6cd7e6260a5e1aae13"
    sha256 cellar: :any_skip_relocation, sonoma:        "267e981c0d5a8d3ab4b301990ce9801f789ad1a947b8f9bc8a7c33c152770c84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86baf5b74e30280b00b8c97d71a72eac337584fc94a2a2ba20ca9c03c31094b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebf5e59bb9fdcf0c8ff70e90c47a41ebb03ac4ce529606bca4e1ab3c89bd99a9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tfstate-lookup"
  end

  test do
    (testpath/"terraform.tfstate").write <<~EOS
      {
        "version": 4,
        "terraform_version": "1.7.2",
        "resources": []
      }
    EOS

    output = shell_output("#{bin}/tfstate-lookup -dump")
    assert_match "{}", output
  end
end
