class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.6.3",
      revision: "f1a48f01c0249612e85bc51b0074c51e113bafa1"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0626d97844a572a4f44f07eae9afea49b1132d77f98ef9136ffe280ef29b599"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e71ffafe350e8aee9c117333670fa0a9ec90d010684d063ad18d1bbcc6dcbd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2eb55202be23c3bdffdb21775b8ccdff1871c50281ca48ac62dd7817e7836ebd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d98c7ea0f3d4f6c68baf8a785d96851a434d00fcac97205b200d139d4e23848f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c17c48b03d15ef57cac80cedb6e292d5a637bb6b9626728eb5ce957f83fb8d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "197832980b3dabfea413eb550836f73d7ac2fe5fda7464937c3c40625027463d"
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
