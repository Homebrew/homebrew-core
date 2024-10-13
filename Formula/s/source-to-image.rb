class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.4.0",
      revision: "d3544c7ee6453f8f6f953f6f27b60190b1eb386f"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a98a5ab37e969669f685bccf2236196e23ff4c74778cce2a509b409dc65fdd74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86d37a7f6c6a702bb8d05d8c8796f76e55cc48ec156bd3bae5f9aa3933ae12e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3476682ae853b90d438748d48b7da496f871c2782a77d403f1a1835cd001084"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76c32af61ebb5734abcb32df97317975b4dd8c02fc4d2e5b217e9a0947431436"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bd0c6860b0b4c48527a0413ad6289fe7986480ae937fe4aeb9a54223ae1494e"
    sha256 cellar: :any_skip_relocation, ventura:        "6214f5dfe6af749c5958ce6be9a7cf15053a9c4244693d1deb490b9c8f077169"
    sha256 cellar: :any_skip_relocation, monterey:       "4718bf9923ae17c45495de303e6e8a999ae4d8860ce24f209b23df863c24c855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cac92d497754413810e6b2c0d96a4ea0af34be301fd954ee290df5bf165cbb1c"
  end

  depends_on "go" => :build

  def install
    system "hack/build-go.sh"
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install "_output/local/bin/#{OS.kernel_name.downcase}/#{arch}/s2i"

    generate_completions_from_executable(bin/"s2i", "completion", shells: [:bash, :zsh], base_name: "s2i")
  end

  test do
    system bin/"s2i", "create", "testimage", testpath
    assert_predicate testpath/"Dockerfile", :exist?, "s2i did not create the files."
  end
end
