class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.3.1",
      revision: "a5a771479f73be6be4207aadc730351e515aedfb"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74166e13a4f985cda0ac187183912db38a5ab90e6451f0df88272c6013833568"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5ac084c3947f1729b436f7928760e3b33e26d1929dde39a6f53baee93103b38"
    sha256 cellar: :any_skip_relocation, monterey:       "ad7b00042172816928eefa48fd80e4eb01a6f8ee68689e304addccbe98b49eb3"
    sha256 cellar: :any_skip_relocation, big_sur:        "885c70eb74a6c0faf5cebdf1468820a26ce8ac08a555821c3d419c7725e09256"
    sha256 cellar: :any_skip_relocation, catalina:       "3fbf3469cf68fa605bbac9b3cb726ffc5c1f485d27dcacd4b9310e24e8d165e4"
    sha256 cellar: :any_skip_relocation, mojave:         "c576266fcc9e09cfae7ea91d9bc6f76b4aad025d087cf11acfe94218cdfe1774"
    sha256 cellar: :any_skip_relocation, high_sierra:    "29fb2fc7a031e904e743264878f9a4010e7c5d6aa0a3091ea0ec1038f312a5ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcecc2baa3cde24a76d98e4771268feff6c28f91f8e0b4260c3d355027c1988f"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "hack/build-go.sh"
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install "_output/local/bin/#{OS.kernel_name.downcase}/#{arch}/s2i"
  end

  test do
    system "#{bin}/s2i", "create", "testimage", testpath
    assert_predicate testpath/"Dockerfile", :exist?, "s2i did not create the files."
  end
end
