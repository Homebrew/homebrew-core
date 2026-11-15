class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.6.4",
      revision: "7a7c7d8af341d163d43198d1a6529ef4042fb989"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7efd521c16af4025e1ec8d1429ab09daff18e4513a1e2f83b77f874364830581"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8c06e0f36e185aaaa07d0b4bdedbf52f09f291564da99049d8d739814ec7bcbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e814e974a12fac44340415b99c12008244fca6cb062e30af392b3f8c1aade3d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5ce26921c24ee2641eb56aa887ee3c9268eb9999c8337f08858c569037fa620f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a0fe773a735548322880dc3eb73b81a9a28f4213f9adda2a1117d283a51f64e2"
  end

  depends_on "go" => :build

  deny_network_access!

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
