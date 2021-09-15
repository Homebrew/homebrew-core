require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.15.0.tgz"
  sha256 "96d2f68caf6bb68187da619ccfa305f8d85126a2e5199b2830255a6b1fc9a67c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "df4487f4d2822294ed4bde9b4f8af1a67bf23e467dceaba168ecff50c4865b8d"
    sha256 cellar: :any_skip_relocation, big_sur:       "58babe7098da230bf1daa9b7e7838b683ee97b7a82d6a68e32ac1dc9699f8f84"
    sha256 cellar: :any_skip_relocation, catalina:      "e3c6ee7a64059050fed8b4577af8711be23d63c0e765371347842a4233b36d3b"
    sha256 cellar: :any_skip_relocation, mojave:        "de43242aef253303a8303740989570dc99a2ec2a9015668064e14ce4ec4a4d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b396ddfa00af45a207b18615542e7d82257ef808da5999c6e3f8a4efc1619940"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bash_completion/"triton").write `#{bin}/triton completion`
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match(/\ANAME  CURR  ACCOUNT  USER  URL$/, output)
  end
end
