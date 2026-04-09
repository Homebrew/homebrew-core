class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://github.com/vultr/vultr-cli/archive/refs/tags/v3.9.2.tar.gz"
  sha256 "27ec2e67054d92c8b8a868be3ee88680f12b72dca7fe9f690371542f89747e0f"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37287f43600261e3db244afd905bb03954ae2ed089591d9c3a7f8d3d0ef28445"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ae78af808bb9ad831410fa5448ff859cfb98e285fa31aff6e9647bace2f6763"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ddaa4376aba659247c84db287d4bc5254918e0e5ad15b9917237f2b4a49398b"
    sha256 cellar: :any_skip_relocation, sonoma:        "68b37d5d49dc92ca9f4743e01455039fbb345196c8265b57050250fc435d6978"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ac796c0b850d269e6bf051c731e5c35aceb9c4380527e45b681fe4d3fb9b622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa0773cf3bba1d7112d9e8c875467ee33108ad93c45be677ab55c03adb2a81d9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"vultr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vultr version")
    assert_match "Custom", shell_output("#{bin}/vultr os list")
  end
end
