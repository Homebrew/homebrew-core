class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.47.1",
      revision: "3759841c53fab263dafa1a7dcba3b394122dc40f"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "5e563b2203791b04a3fa38cf6f7276a50a21cd5830517d693f4e63c768f2dd64"
    sha256                               arm64_big_sur:  "9d4f83ce68758cce19c65c8bd30d9e1300de6e3c5d84448821ce4d9666a1c7db"
    sha256                               monterey:       "6f473f81f5cea4fdec023fa36df97e3dc3ec12e924404f661ef868dfad3b93c5"
    sha256                               big_sur:        "d4437a44b14bff228daec3b99be0980f261957822b70a17c9b3319bcb9ca8748"
    sha256                               catalina:       "746ed7a861b3561d45c6f290cf8e7777e42e648c6d76e1e2fee2cc9cea6f2ff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "575e7588c5377dc7af0592ad2d7279d3c76b8d97add0881e725d2736123c9b4f"
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
