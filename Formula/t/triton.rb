require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.15.5.tgz"
  sha256 "e8abc804b33877db9853386854bfcbefe9d581259ffdb66c34f9303e9cae2ccf"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de6bfe7cb24a6330e77b82b69da5ba60d50adf6ab56889d76bf025f34a525796"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10955b249b0d8df311d0ef4a375a1423bfe1180b2347d0891718fbdda8d5cdd6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4378238a4943d9c81260d5c240d0ca84c7786be5e4a155ad6ec95809df9067f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0e935a9df5165bb7242e8c437248e7fb67fd047190d0d65f81a9acfeac2f702"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1d0b1713fc07290cd51365c0bac120cc25c42f57d2c18c4856b2352c5dfafa5"
    sha256 cellar: :any_skip_relocation, ventura:        "1332dd81ec3bcc3e86e5be5628bfb538a7bfe7fcaff4ea1ab4a6c028d86ed623"
    sha256 cellar: :any_skip_relocation, monterey:       "8ecbceb11956c610c6aee65374e5260440f31ce96bc96b763e11e18a8af45fe9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f5cc33eddadc31c0f70034ce438aaf5b49d241517ce2d50fdce9b67834cc144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6147ed98336e4982a30521bcc4093d0d92f10583d82e7f48e0858ed07fd42f5"
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
