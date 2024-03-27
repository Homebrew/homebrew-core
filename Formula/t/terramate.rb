class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "580f8afdba85e5feb8ea5ccdb71eef3c144c32ff757f321705882a41381c3dfd"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b33e089460318605ed91bbe68f215dad16c750cc052a79e9af884b431e2f7981"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc2745abad5fd6647e72a91c88507f8c79a00ebc9ac3c6d43b4bb322484ad8ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bdb07d25708f01953175fb14c7e950591ab1ef9293b457e5408ae40c33bd970"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1ae03d8bce02af37ea20ca502097c146421be4306bf6d4659188877f00c4256"
    sha256 cellar: :any_skip_relocation, ventura:        "8639a85918d04bd9d2d682fa73e6d05d3d2eafaca5fc2f5ecd1a47b71daceada"
    sha256 cellar: :any_skip_relocation, monterey:       "60c112c8977a6436ac5de81c27009631a1ce2f97d2f2baf6fb08956a153436d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f99a236c3ce55fef031f7464b1dea66b528e971a7f7c9f92585ec2337985cf5"
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
