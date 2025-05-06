class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.54.2",
      revision: "254f658a657dd8703cdd01663148dea14c2dabff"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3cca71b6d1ea27e92f5fa79eb05d6f21bd36ad8cf2b271d281e467e734a8a1ef"
    sha256 cellar: :any,                 arm64_sonoma:  "cec093409e5ae1e38933e65359969db77a2063f38b7e7fca5e9e954263815ef6"
    sha256 cellar: :any,                 arm64_ventura: "0fe8a5beb7b45731459239fca1fbd7574d72c1abc5571e060671c7547617418b"
    sha256 cellar: :any,                 sonoma:        "2c79f8d40a3993c2abd591eda730c59dba2a9a650933027144ce75dba764530c"
    sha256 cellar: :any,                 ventura:       "c693000278be5acd0934127e53b5fa4ba8df6f68c9d428269c53302fcca5784e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9fb91ea6fb244c0313eb2b9d4f3303515182a044b44d2a138d514daaf76af8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f30993e8b37e669746f188c1df9c361b1b5e3d2575d4683d891042731e51b56f"
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
