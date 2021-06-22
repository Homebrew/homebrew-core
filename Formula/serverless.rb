require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.48.0.tar.gz"
  sha256 "440507056d2081ff61762ddbd65db4529febfba393f5347b812c22ad5b646748"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "b8cf770522f93d0e7641ece5e6541e05233a0b819a879a506acf9fe2eabf2667"
    sha256 big_sur:       "dc451b6562e43d4d3fa1b139933028bd4a44dbea1950416f3eab5f08bc3f57c0"
    sha256 catalina:      "6e1bb594023b9d1afcd2f3e777dd6860fed6d856bb3a9b486a7d7b5d064c6ca6"
    sha256 mojave:        "804c3943b36096d8e75259ab460c35b0a0c7ce5fdea344acb434ab3d341d4f5c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"serverless.yml").write <<~EOS
      service: homebrew-test
      provider:
        name: aws
        runtime: python3.6
        stage: dev
        region: eu-west-1
    EOS

    system("#{bin}/serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
