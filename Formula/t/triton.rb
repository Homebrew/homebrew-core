require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.17.0.tgz"
  sha256 "00792c7668da5fc711e79cce1ee130e3e4adf5696a622b995f7b2a4127a4dc7f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a66f2366eea24eacb2940b327488b27e2b26a6d5737693c375326364367c4c40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28256a7d9f35ea60afd891a0d172343ceae27c621dd6422d17e120abcde14b85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30102eb7e18ddc9be24b2cf213ee65ab66e06e9d83ba3c7685f5dadc3ba72ee0"
    sha256 cellar: :any_skip_relocation, sonoma:         "fedbf78360820022b214d3dccb7901af846079a8d1603721766b7aa44c6ad5f1"
    sha256 cellar: :any_skip_relocation, ventura:        "338ac6c0a0aa62fbee00380cbea7eff8af1b89635de8d0fa0df8b83b0928b3fc"
    sha256 cellar: :any_skip_relocation, monterey:       "40bfc0f5e498f35154dbaee91aa9ba479def608d0ceff6e93abad4c1fcee1281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "638cb432ca800e41a289be9ed827f94a96e827c38a4cd416540c0fbc4c17b75e"
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
