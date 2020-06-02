require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.72.0.tar.gz"
  sha256 "bd00ac97ec68b81c1621d45d6f236d2f3c022f597cf81d7f281c2377d62bfed4"

  bottle do
    cellar :any_skip_relocation
    sha256 "1297141373119832beaee0ba906ea096309d78047c7622fbe10f3b8ec8d865f6" => :catalina
    sha256 "b6dcde83c58dc681f709634ec50b37b05f98264b43a6c161e0fb8445d9dfdbf6" => :mojave
    sha256 "063c2dd7f94ea1ac711776f3d0b89e20cca1c9aebb18997fa46ca3a3848ffd87" => :high_sierra
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

    system("#{bin}/serverless config credentials --provider aws --key aa --secret xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
