require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.15.4.tgz"
  sha256 "6f278bbe525440b66b35ca14535803d01da9664134e6a1a0768aff09c0ec0cbc"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb0a95e479c88711d1e0daf3c75e70fa7e71ea6bbcaa333ce7221ba81cab32e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d725c047beab2fca0a59e491187a1ef11bdf8eb529d7e5b2a50615957b500449"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec893718f4f435874aac09f68928bf358fc1ee9a69cd8d8cb9c3d0018a8efb36"
    sha256 cellar: :any_skip_relocation, ventura:        "2b85dab7065adea77dd2d3734b2df682dbcae72d657c0196474e4bfe9bb34ac3"
    sha256 cellar: :any_skip_relocation, monterey:       "dd61a9d9ed2e69b2057590d6cd905cd4fec8e94364caedc22ebc3bbfed22de8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "423b405a415d65e1dac57ad98b55a6211197c402227d406b7ce95432291b5ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d18918fcb06e944c69514727625d2b7545e38bf9ad7693a4638027131f547c7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    generate_completions_from_executable(bin/"triton", "completion", shells: [:bash], shell_parameter_format: :none)
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match(/\ANAME  CURR  ACCOUNT  USER  URL$/, output)
  end
end
