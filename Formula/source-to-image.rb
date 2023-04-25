class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.3.6",
      revision: "cd7d7ce9fd7532fc1e273152e9f2a1b5b76cdfca"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47f1a541749cb2fbd129febf1e8b61069970287473dc9e3aa8aa8cfbc249dede"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b3078161cefd110d7c57a3fed78a13f77c72feccdf7a9c6f2c5da49006596d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "446734cab9cbf313cef235cf2af745f33c2ad1f55f77ae3fd7b5c9d31d5299bc"
    sha256 cellar: :any_skip_relocation, ventura:        "eb84466248c83b1ba2a0b2925b971928b7633c376514d8ca2998360c44e2d168"
    sha256 cellar: :any_skip_relocation, monterey:       "362ef120cab856462a322169a1033462c5215c9a87d840d44d85f86fb47eea0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "617c08c174f94b5b3e96397602cdee3ff4bf31ffc2dabebd0258faa8cbbeae2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6041df3b76ba024c18e485d73dec6f1df68e4651c5951cfbcd609ca48468920a"
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
