class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.3.4",
      revision: "c6c9fedfe04013db9f7ef064d1b6a3583566be04"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d6b262477f1d9c8fe6c34765ba9ab6eff75f0ea7027ce9da707946239431178"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e8be455200735713e114d0846b16837140b1ce18025328a917e81a62a163d5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5eb939249e6146297743726682ba7eb09f7685fd3c77863b9d434ddcb8b1bca7"
    sha256 cellar: :any_skip_relocation, ventura:        "270e5b6d889d9c47e71f513d16e175f39dcb3fcda7a87adab29478140a2d601f"
    sha256 cellar: :any_skip_relocation, monterey:       "398f509b1602cca1b26db587883a751ec3d0d5af82544874f6a338b72dd482ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "fabbc3327917ab8467c3ee7ca29d14c549cf6a8f7785b51dabb55e218473c85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b5805a5977b3b58135a3b221f59c899715a9a64d9b87a104a8de9f83c5a8732"
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
