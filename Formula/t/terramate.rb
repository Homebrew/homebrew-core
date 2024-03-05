class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/cli/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "ba61a8cd832aba3bb644d1def5f5b9a3f42641aedcd46dc029e0f5a2cdaf058a"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a338ea0db33ee26086ab1b4befb852fc44f377ec9afb2cad8f37f04b94a8ae1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac7d32230a32dc0a291c23981d50fe1d7016683aa98848fd1437cd911cc2ba28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b209586fa295bbc17861fde4ad204fa353f964e85127a5de9a48c7ce63e0028f"
    sha256 cellar: :any_skip_relocation, sonoma:         "13222020194b02fb603dc97de26cbd1b371ee429b48e076a6102a9f5f76ab68d"
    sha256 cellar: :any_skip_relocation, ventura:        "2d0f8be202e6e346740b088b633fb1d35eb25d9dd989651dd846219ed3995fe4"
    sha256 cellar: :any_skip_relocation, monterey:       "99358fc8432761bf3da388940fa496179d3e8cfa7713598cbbb7ac3a7264e94e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c67ce4a790168cae731d1d2efb4b596d82c8f35bda5487b381edd9068fc6096a"
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
