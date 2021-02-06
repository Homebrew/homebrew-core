require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.12.2.tgz"
  sha256 "090b6b39359354ed19c4633dd7d4fa14f53d74a4d81449ec8535beeda0b5de22"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5ec9a519d279db791a9a2ba2df1555cc1fc7ac18caec1fed6c03e8281ff05c98"
    sha256 cellar: :any_skip_relocation, big_sur:       "2432730a23b371f308fc65ff859f290edec33886cc4e1f434d2f31e53b101132"
    sha256 cellar: :any_skip_relocation, catalina:      "a5dcdafdbf31e722c90ee98d49dff3fbdb3c2534b0829e6de7a3bd638dee4f49"
    sha256 cellar: :any_skip_relocation, mojave:        "46eec03b96a0c947df6f59d13f1de651d7905f652abad6cfbb0c97f62d0c9e96"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bash_completion/"triton").write `#{bin}/triton completion`
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match /\ANAME  CURR  ACCOUNT  USER  URL$/, output
  end
end
