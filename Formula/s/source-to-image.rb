class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.5.0",
      revision: "aa5e5680081ed2ba20ad91cf3e0c3bcd242bdcd5"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "712a7210cbd6d3a5b3cf2f9c9353a4852a175d8ba8260036d249ac56e33fbaef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24a4064c4f68963cb9b49f8856a6f5919645fe887a6a637d5de4e453e4be7f67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa538c25c7eae3ad9bab46fbdb0b30bcbbc605dae5b71d99910f712f6afbe4e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce38585c88d6e803123974ab374dd585f2241638dc14bd79d8c599cc4f3bf2e1"
    sha256 cellar: :any_skip_relocation, ventura:       "d01daccfdd4542b6149624f6ed92520d1772ef42b1123286e4a79e4989afd65a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "492c132b45630ec2b851a5e764dc34f5306647ec137f31f246386689abf6df7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92044d0bc7833e792f5843fa634889fdf843ce0132f1791fd282af63060a0521"
  end

  depends_on "go" => :build

  def install
    system "hack/build-go.sh"
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install "_output/local/bin/#{OS.kernel_name.downcase}/#{arch}/s2i"

    generate_completions_from_executable(bin/"s2i", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin/"s2i", "create", "testimage", testpath
    assert_path_exists testpath/"Dockerfile", "s2i did not create the files."
  end
end
