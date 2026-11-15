class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.18.1.tgz"
  sha256 "36804146e9df26ac633524c7d800500f02d9c0ba6b76eb9bd4b5738ca34cbc09"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f68d9e7949f93e904bbb511141079060865c3010fc1754ce769c60db8b07ffee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5e2fc59e5dc11f707ca0dc2bc64c7c43f344ec0758bde9602a4201d7b2a0ae62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5a1e1ed18033d309e6301e44fb0d013a78392c4d4b86a8b0b5236fad29a69bc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f269aaf062966e6564f5a3fcc9ab3e97ac6d53dbe1f491865eeea0f4aa944420"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5b57fa0ad85a96042b2b2427728e54385c4bcc2f81c6fea100205570337ee228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a2871b8d302dd27f043c8ab145331593a6caa1089ee1f2824232ab3e7796a4ab"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
    generate_completions_from_executable(bin/"triton", "completion", shells: [:bash])
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match(/\ANAME  CURR  ACCOUNT  USER  URL$/, output)
  end
end
