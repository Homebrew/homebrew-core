class TfstateLookup < Formula
  desc "Lookup resource attributes in tfstate"
  homepage "https://github.com/fujiwara/tfstate-lookup"
  url "https://github.com/fujiwara/tfstate-lookup/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "d01dc5ca5193fd38696fcee0b8fd3f7211f9f12fdfefa46403a6159b9d677fa7"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d19503d32c192bcbfb3f1d7a3c6b8d4df2a0515517ba3be3d86efca31a4acb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d19503d32c192bcbfb3f1d7a3c6b8d4df2a0515517ba3be3d86efca31a4acb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d19503d32c192bcbfb3f1d7a3c6b8d4df2a0515517ba3be3d86efca31a4acb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "83183818fa7570df272d24df9b04be0a9d890065e71e23219252e9cea69d4be4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d3915e141961b0eba102a84ea975f137d71b212931c371962bf7b025308eb0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf9e9304ba1f0e0ecc1499e9f17711e0cb34b6d589a1485646263a3a89143d58"
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
