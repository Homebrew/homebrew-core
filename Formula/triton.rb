require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.15.3.tgz"
  sha256 "5a7037865c922acd9eb12463313d389aa43f0d953552913a38ee1ef9d5648453"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bfb697794705cea25eb02009f6c4545a6ee7bc029a4baf9eca450a14df92adb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7279869b315cad2031654f570aaa58af336ad9799adeb89a5fb7299ddc61010"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "408d96230df04b42031c4e72b0d8e1e8ac30b3f03ab7183eafdc1dca9d69b622"
    sha256 cellar: :any_skip_relocation, ventura:        "6086656cd0e525bd9ed989d106122654a8ca768a061057d822a935c279b915c1"
    sha256 cellar: :any_skip_relocation, monterey:       "b1a80ab4ae75b3d439ed833ef60e08244bdd2f619b39d77ef3a9b3aa2a07e3c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4ecda6e5894926376fbcca3bc2289c1d5f4450c452002d91d4c8aa4359e24ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a86b2a34f3d5458173bda1301d4d219315f03f2c781a27321e8fc451fdd72bbf"
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
