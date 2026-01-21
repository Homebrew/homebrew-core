class TfstateLookup < Formula
  desc "Lookup resource attributes in tfstate"
  homepage "https://github.com/fujiwara/tfstate-lookup"
  url "https://github.com/fujiwara/tfstate-lookup/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "3c6dea9e390dc3213aa5c7fb2dc2f108f26864bf1f7d1ea1b5b3228346507b48"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70e1f0b2ca9a4e85251385f758ad3a9766563bf9d89ca0e0147c1cc097517470"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70e1f0b2ca9a4e85251385f758ad3a9766563bf9d89ca0e0147c1cc097517470"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70e1f0b2ca9a4e85251385f758ad3a9766563bf9d89ca0e0147c1cc097517470"
    sha256 cellar: :any_skip_relocation, sonoma:        "eff229dbea67a1c53b07c7307b0392c6ef6865925ead8de3e31b9d5933c61273"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8949be6c379c85414cbaa8a9f6805661f8e5439fb66fd318d2fb34d12a336d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22ac5ad3837878456910f8e8e692c20a3ec50953f96edb98b06bc8c28f1ec18b"
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
