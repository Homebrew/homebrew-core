class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.54.0",
      revision: "ec0b1a2b0f2898bcdb6fce5f19e1cf89b31c195f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6c326fa0168821082dd87a174affe25d869873d7b3731bd6e0ac5dc8f45fbf97"
    sha256 cellar: :any,                 arm64_sonoma:  "65dbd28c0be7f5e6bbb8121563d3758701cd76c4cb9761431478bd2034c9b141"
    sha256 cellar: :any,                 arm64_ventura: "91ed642932258103ac91623e73deab115b0403cde2dd4366b3cf9afc50327293"
    sha256 cellar: :any,                 sonoma:        "459945c690a0fdcbde799a516d3c1afbb3112b3d35760aa76374da2d8e114fbe"
    sha256 cellar: :any,                 ventura:       "c458b5c09b87afd10142af50a60f6f9fd4528fe902be48c1eaa8cb7a583e39ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91836ba49b401cf1753c0c3f1266dbdf5aefbf0f96886e9129523c9f06693d66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c8268944b9eaa9ba416ff203de7bf845fb38c70e899eaef77643b1a360e2731"
  end

  depends_on "ruby" # Requires >= Ruby 2.7

  depends_on "xz"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"solargraph", "stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
