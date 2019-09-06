require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.5.0.tgz"
  sha256 "b6349e353897391e29a87101b22baca1db115d06d29ae0869b6630d4bbe70926"

  bottle do
    sha256 "7257584fdd668f5dd0879a67754a37bb4c270b8b8367c9c6c4f7531aaaa2972a" => :mojave
    sha256 "bc881b355bb3582c34f2a6deeaf44722ae0d2f13c4210242bef4f7bfd7889212" => :high_sierra
    sha256 "c345740c4b8d3a40dbf5d17e563d5072c52f27628fbc80462df1f989e5a846b8" => :sierra
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
