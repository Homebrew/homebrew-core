class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "ba61a8cd832aba3bb644d1def5f5b9a3f42641aedcd46dc029e0f5a2cdaf058a"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9524bcca507217076bb3721912f59014b01d2eece799c1eb11844469872a3a3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d46f9572f13324de6e8e3de88adbd76ca4fb4ebcb5937d5cca8998e92e3b1a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f05510005714500eff52e523b23f28bc5c3715a0768bbd050469e8c1e269fc6"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9b2cf304c5c07993a51886f1656dce0c1302f1e064f5db8568dc3a5080d2260"
    sha256 cellar: :any_skip_relocation, ventura:        "b70aa48f2fe60b1441386c20694ff437c225c3d411997197b9591f0e5d1aca9f"
    sha256 cellar: :any_skip_relocation, monterey:       "22ac183405e190aaa4d8580719f970915f42cbd6f846abfa47202d539ec1e9d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8bb82dfe4847b7d38e61600e208bfc636c16e1ed9e017ebd896fc197f7f7a7b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end
