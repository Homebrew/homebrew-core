class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.3.8",
      revision: "980ca195116928b3beb61b25d5939d0044b3040b"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f50ed6d499d0123e959b5027f6897cfab3daeea0a8369f77d43090e7a8a8af86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e70fe8a14ac7600b9d273343410dd40e0d7f75d8df041367f3a83598423fec36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a234fec43b13d68d62d3827cb9c4f76820213b99f8b2203666b2d0632a62cbc7"
    sha256 cellar: :any_skip_relocation, ventura:        "5a72887cdd4f0132ca6349e01a92c94e2d143a3b989b4b130c775a31a7b9369a"
    sha256 cellar: :any_skip_relocation, monterey:       "21f8b669dd230f4d8749b6da504453c3529d0322d3ea49824f0b82d272313eb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c1b253eb3a2c8611cae470735df04eb0a73165acb9f5576236090381b56dc1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d39b5f8f2348c6ff07fe3be0575f9df5e81a45704f84b58b9b556ab3dd55821"
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
