class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.3.9",
      revision: "574a264097de0c4371017bcb1bc3e6f95f8d3690"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "526491cf1ce64d64e31308e14345183b9fdd27af8c388d32132e704eba9ba2da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b1a00089afe93f7d0fffe09beb165f9b763b6e0d73e591e57e011b0fcd51328"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8281b0c9f94926a48cad2697a608b276cecd2976425854fbeff06dcddb78f1f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "48a9bd6eb1ea6b3827f53625046ebbd14b2a03b966b87a3ea0d8d8d6caf1d7ce"
    sha256 cellar: :any_skip_relocation, ventura:        "63fe8ca698084ac1aba04f127dbba0f82e9419376b449797f91fd30cba88423f"
    sha256 cellar: :any_skip_relocation, monterey:       "aabb501a339622a73d2bbf8071d3273e6f430ff8c91e5d806d4c32e3a0705770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c9718ac5e524a428c7561cada000e07fe1e72da62aef11464e64f71f7b44809"
  end

  depends_on "go" => :build

  def install
    system "hack/build-go.sh"
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install "_output/local/bin/#{OS.kernel_name.downcase}/#{arch}/s2i"

    generate_completions_from_executable(bin/"s2i", "completion", shells: [:bash, :zsh], base_name: "s2i")
  end

  test do
    system "#{bin}/s2i", "create", "testimage", testpath
    assert_predicate testpath/"Dockerfile", :exist?, "s2i did not create the files."
  end
end
