class Tfschema < Formula
  desc "Schema inspector for Terraform/OpenTofu providers"
  homepage "https://github.com/minamijoyo/tfschema"
  url "https://github.com/minamijoyo/tfschema/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "094f8a3c80bac1afc8f03a979625b1334eb5318261f8b8fec9f20ebef3d3d14c"
  license "MIT"
  head "https://github.com/minamijoyo/tfschema.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "74eb616a07e9b291ef3a898fafdada0863bfae1fc9f68c35c9296d9999b87f89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a26bacd3c1d2c3181c66869f2073433ffd6e22e5886a005d1c5f7c4cf975421d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1b3e06b4e54a071f7de0ddca39efc3c5d907d683d43ace34bb58f6c67aefb70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5226fa144a7d62a560b71935d21f5ec06bb8d012ff52a96c446e27ca071faea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e97f4365b1120a43460e1cf0f9a315d656835844c7e74d812c6e283ff2d6009f"
    sha256 cellar: :any_skip_relocation, sonoma:         "211f9e3b81ba3ea4718527da5163c9601cf047e1a96d1150633e18629e0a0e9f"
    sha256 cellar: :any_skip_relocation, ventura:        "d49710e06a136faa07a494c6be24b5f0b549edcb6ef4a021d29da09b626798e1"
    sha256 cellar: :any_skip_relocation, monterey:       "7c9bc506e3047c96c6e816c631b9d7c106fd2f7569413c1fb27eae986d8a6f97"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5520369f0f5296724c0d5465ee7a71be144c9a73762c9f3797a809055bc68cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cee668cff712e456427c14fc7945eebc14812aa148194a4898bad8017933b70a"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"provider.tf").write "provider \"aws\" {}"
    system Formula["opentofu"].bin/"tofu", "init"
    assert_match "permissions_boundary", shell_output("#{bin}/tfschema resource show aws_iam_user")

    assert_match version.to_s, shell_output("#{bin}/tfschema --version")
  end
end
