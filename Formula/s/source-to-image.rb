class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.6.1",
      revision: "906fe48afe651f5cc79e1f3f8c0a9110d45a845e"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecfaba218333be558d243c14f0eb058343e9db76a38d66ba09bc1b30a1b70455"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1296bca7775e383b42c3c44ba07da4147b501489e1b872901e3bf440b9976a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "958b65fdbf6e6519bb94eb54a18672719f8c0330bb41a98769661e300e121c28"
    sha256 cellar: :any_skip_relocation, sonoma:        "89e5a7f8027084ee2bd5319349a631df7b746b3b40e54c6037de162c65570aee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "960537ce378df0c19d3b7fb8464cab4ec3cd47011cec92f4fee2d6f5a28bcc25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f413097b782eea537b0e6faa1aaf4d4df37130e86de0240670aad3dd545e0a0"
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
