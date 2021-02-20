require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.25.1.tar.gz"
  sha256 "55fa5bef0d7fe5d0fd8b2de4e546ec4899523c162f56ac3188f47fe5e8bbbfca"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "b28ad6a6b6a49de6af57b614f156d2da5889aaf1d75622ab64c9450c49703598"
    sha256 big_sur:       "5f6a22ac463ca4b0ab32ca61a4592a7df70e8c31c52d0d5a7e7f9ea723461387"
    sha256 catalina:      "243ccb908856c5f1e2760d3bdabb253b5022eb821293ed74558857c0be668266"
    sha256 mojave:        "d31a8613d93891f9fe04ccae3d22dfa5ffa48667d0b4c49268c9b172ee3105e5"
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
