class TerraformGraphBeautifier < Formula
  desc "CLI to beautify `terraform graph` output"
  homepage "https://github.com/pcasteran/terraform-graph-beautifier"
  url "https://github.com/pcasteran/terraform-graph-beautifier/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "81aa8580423c09fbfe2e83a1d52fa9821ba0fe744b08b3d8219d2174a0c86e13"
  license "Apache-2.0"
  head "https://github.com/pcasteran/terraform-graph-beautifier.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d24aa6e50a61929927e8e631079e0eba0b5a21a7e0ab8bf40b78431f00f2605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0aacc3089abbd6c7d7867922d1cb6aa74c0006853e6d1660ae0ca36749b091b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c483405fb2e2b7ecb6c073dfd5895a3934c4759380138c208c0f1bba04a0cd5"
    sha256 cellar: :any_skip_relocation, ventura:        "afa6c83389aaeae9f1332971aecf9cb97d5a390edfbbe2d095afebb6e68c72d5"
    sha256 cellar: :any_skip_relocation, monterey:       "1e43bf628f0dbd289047668930417761b46a716c3b3349d17766be95b45dcb8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e02949c236a33b838e6811977359437acdaaa26e078698db6d094a6681b1559a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f64b3d57aba3b21e0d6d9afc785528c2fee8587bf9b68e6a8c7c48c7ea81856d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
    pkgshare.install "test"
  end

  test do
    test_file = (pkgshare/"test/config1_expected.gv").read
    output = pipe_output("#{bin}/terraform-graph-beautifier --graph-name=test --output-type=graphviz", test_file)
    assert_equal test_file, output

    assert_match version.to_s, shell_output("#{bin}/terraform-graph-beautifier -v")
  end
end
