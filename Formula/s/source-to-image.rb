class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.6.2",
      revision: "038c647b1a9046569c07e6159641786a67a990fc"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc60210d55e1b120ebfb37af3be797ee4ac9ea41d46db3d7415b290e49d8e803"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0358433a08fd678fedbcba82228db3d49da01a46989368c33cf1c4ab6ddc04fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f94951dfd598acbd9d6c0bc86c8e3e73a2a33f2fb7997616dc97e9b61bfede83"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e998d3c73938bfd1adaff8b89571746a19114d25a2b1bdad445b1b0f6500c9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "704b4035043fed114078330f1a746b0c30045254475bded3b077384fa07085d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9983b5c7dcc291cdcf4896906e5c3c52495ef7b9e8c8c1382130266b7299c81a"
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
