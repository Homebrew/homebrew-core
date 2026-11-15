class TfstateLookup < Formula
  desc "Lookup resource attributes in tfstate"
  homepage "https://github.com/fujiwara/tfstate-lookup"
  url "https://github.com/fujiwara/tfstate-lookup/archive/refs/tags/v1.12.2.tar.gz"
  sha256 "56cbf8902e8fd071030a8f0542e6672705d8296dd0e9478bc30a36a6e4a465f5"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3222b9083ac37f69b7509027a288fb670ce30dd3e7eb6f532e1205e23256d49c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3222b9083ac37f69b7509027a288fb670ce30dd3e7eb6f532e1205e23256d49c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3222b9083ac37f69b7509027a288fb670ce30dd3e7eb6f532e1205e23256d49c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e5a29c4458e70baa511637b58c8bc8e7bef4d366315c0eec1d2eddf80233527f"
    sha256 cellar: :any,                 x86_64_linux:      "1bae57767fea1d0b9425d5d14c2bb1fdcd6d351611ee7cff69da0346e5802312"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/tfstate-lookup"
  end

  test do
    (testpath/"terraform.tfstate").write <<~JSON
      {
        "version": 4,
        "terraform_version": "1.7.2",
        "resources": []
      }
    JSON

    output = shell_output("#{bin}/tfstate-lookup -dump")
    assert_match "{}", output
  end
end
