class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.47.0",
      revision: "f90c17e8db083f80b0991b11ca1a469806cf8191"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "b62e75f50d70715eff11165225b9bb586275e44ebef301757c7cfa4f0d44e48a"
    sha256                               arm64_big_sur:  "a26c960c5346fcd60a170c4ddc2366c6c6dae488c59681efa2fc4e434abe4e4d"
    sha256                               monterey:       "102afc448910acd5510b8ec99951ae79bef581a8f5fb1fe94859c63d4c78cb36"
    sha256                               big_sur:        "92385aecc8e181730af066092ed6cdd4564ae73296b10e19a0cdd9f1eaddf7a8"
    sha256                               catalina:       "67b3191a77818c55cdc713c96c085c299ed0c6f97f5f5494b020c07b1d30f731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "866fa03f6b364320e3999ea18ffc9b1ca98cd2661cbf23750bfcb24a16653944"
  end

  uses_from_macos "ruby", since: :catalina

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

    Open3.popen3("#{bin}/solargraph", "stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
