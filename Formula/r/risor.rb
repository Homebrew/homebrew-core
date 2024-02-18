class Risor < Formula
  desc "Fast and flexible scripting for Go developers and DevOps"
  homepage "https://risor.io/"
  url "https://github.com/risor-io/risor/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "f8fd64b5a453eb30b4501bea37704e85cf6691d2e8fed2e71a0a674c0950635c"
  license "Apache-2.0"
  head "https://github.com/risor-io/risor.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0737272f745ab5d7e014787255aff399d3fd679a7711bdef6670e32f25db4659"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0620382c90969cd980b81106faaad70a4fa2b3c5478a33f5d798b646fd544fd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ba207f47e79ef3604bba2e67a81ec4789b4a0023b48464700c7e6863ba92827"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4f7dba00d13fecb8a870654f4651608241e73afdcf0fceb061546181dedde31"
    sha256 cellar: :any_skip_relocation, ventura:        "22f7320f621bfb58a20bbe973f5e4a0cbeeba62163bed4729859d7d5e2c253c2"
    sha256 cellar: :any_skip_relocation, monterey:       "6ce019679f93833d564547dc229e047668163f816dd88523e3c3bdd21389433f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5753d148cbe773c4d6e3c187fc5559ba83c8d6eeafc575c9e6b752576a32ddfd"
  end

  depends_on "go" => :build

  def install
    chdir "cmd/risor" do
      ldflags = "-s -w -X 'main.version=#{version}' -X 'main.date=#{time.iso8601}'"
      system "go", "build", "-tags", "aws", *std_go_args(ldflags: ldflags), "."
      generate_completions_from_executable(bin/"risor", "completion")
    end
  end

  test do
    output = shell_output("#{bin}/risor -c \"time.now()\"")
    assert_match(/\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}/, output)
    assert_match version.to_s, shell_output("#{bin}/risor version")
    assert_match "module(aws)", shell_output("#{bin}/risor -c aws")
  end
end
