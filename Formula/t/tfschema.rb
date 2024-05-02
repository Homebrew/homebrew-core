class Tfschema < Formula
  desc "Schema inspector for Terraform/OpenTofu providers"
  homepage "https://github.com/minamijoyo/tfschema"
  url "https://github.com/minamijoyo/tfschema/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "47ab332fddfcbd9ba1e533f6271a386b91ad8e41ca655f7802bba3fc3efe95ce"
  license "MIT"
  head "https://github.com/minamijoyo/tfschema.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "673539d9e54df4d46ad4d8872e1d07cba36dfc38d8634dc721ba58512ba04caf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5bf47df6528b4fc1af46111b13fd0814fac76d1bf4b5a1e7d341200a02c919c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b26f4e8796cd10e7b9b14f5404bcebf88896452e66a46bdab94077db66489650"
    sha256 cellar: :any_skip_relocation, sonoma:         "728683b57db8ae8e9dfc0c051edeaefee7c324f2dd95ecd1bf57120e8f08a071"
    sha256 cellar: :any_skip_relocation, ventura:        "eaa254580250c78e398bd494895ed5d413714656cc1989940839ef5ab3d8e41e"
    sha256 cellar: :any_skip_relocation, monterey:       "c590664ca38e3db64fce7f983d96683d7e54a3cee5dbf8ca00881b9a80f670db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "060f5e55c776e6e9450084d439151faf2af6b26c6ae5a9c24bd7140d7aeec8e7"
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
