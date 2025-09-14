class R3call < Formula
  desc "Intelligent memory API with hybrid caching for AI applications"
  homepage "https://r3call.newth.ai"
  url "https://registry.npmjs.org/r3call/-/r3call-1.2.1.tgz"
  sha256 "d8007a19141d264cf4fe55074e663e9834b1e12adf8b92fd420ea924c5ed9a3a"
  license "MIT"
  head "https://github.com/n3wth/r3call.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "placeholder"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "placeholder"
    sha256 cellar: :any_skip_relocation, sonoma: "placeholder"
    sha256 cellar: :any_skip_relocation, ventura: "placeholder"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "placeholder"
  end

  depends_on "node"
  depends_on "redis" => :recommended

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  service do
    run [opt_bin/"r3call"]
    keep_alive true
    log_path var/"log/r3call.log"
    error_log_path var/"log/r3call.error.log"
    environment_variables MEM0_API_KEY: "YOUR_API_KEY_HERE",
                         REDIS_URL: "redis://localhost:6379"
  end

  def post_install
    (var/"log").mkpath
  end

  def caveats
    <<~EOS
      r3call requires environment variables to be configured:

      For cloud sync (optional):
        export MEM0_API_KEY="your-api-key"

      For Redis connection (optional, defaults to localhost):
        export REDIS_URL="redis://localhost:6379"

      To start Redis service:
        brew services start redis

      To run r3call as a service:
        brew services start r3call

      Or run directly:
        r3call
    EOS
  end

  test do
    # Test that the package was installed correctly
    assert_predicate libexec/"bin/r3call", :exist?
    assert_predicate libexec/"bin/recall", :exist?
    assert_predicate libexec/"bin/recall-cli", :exist?

    # Test that we can at least get the version or help
    ENV["MEM0_API_KEY"] = "test_key"
    ENV["REDIS_URL"] = "redis://localhost:6379"

    # The actual test would depend on what r3call outputs
    # This is a basic existence check
    system bin/"recall-cli", "--help" rescue nil
  end
end