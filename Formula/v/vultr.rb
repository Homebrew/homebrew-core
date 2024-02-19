class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://github.com/vultr/vultr-cli/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "adb287850dc07abcbdcb69aee21ebf38bd19b7f30f039e7858adbc95e871ef3d"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c82b93d215b728d7e4acc53a86c5af4e1b1621fd9321e461e4bcf923591e04b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "494fe5c96611dffea79611b521216bd63f7586a0f010d5d6544c8120a4271f55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11ff2305f60e11d904af1131ad8064df595a53ecf3775d41af00bf9fd58cc888"
    sha256 cellar: :any_skip_relocation, sonoma:         "13d9c311d6bc3eaf9510af9227cb965d1e6ac05e3c24360f454a7bdbd9e4964e"
    sha256 cellar: :any_skip_relocation, ventura:        "64e77dc7619900532263738055bca6f42d756e38befe6b5ede3624884ed84a81"
    sha256 cellar: :any_skip_relocation, monterey:       "b6212b6e48b231a4a8e8ac64f86cd4bd629792537c5f8ef96f2fa4f1139d74d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ccf43103e93eb156063728888339687bc59e979a5582fc6607f95c6c056e789"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"vultr", "version"
  end
end
