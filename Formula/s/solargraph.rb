class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.58.3",
      revision: "d1669eb68f1fb542e999ddbcf7707726ca2b4612"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3198bfaa8d68f01d16e0c77643ed445d7409cc9d307638bffe74fae7f9bd86d3"
    sha256 cellar: :any,                 arm64_sequoia: "a5a12378fb568c36cb123f65e9cbc16055690dd61b0a90547b6c9fdc8022ad90"
    sha256 cellar: :any,                 arm64_sonoma:  "51b998fda9cffcd3f9e3ca5eecd9cd12770a93b6860fc6aa3d2fe69f01919b9f"
    sha256 cellar: :any,                 sonoma:        "bd086d0bec28ebe9b4231205be150438dd89d868dba8aef9141954aec7da787a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf5527026033d2be9fbc281e749ebf279d0d033a5dd9d2e8f6592dc077e5bcc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48a89d68665b532441aba666dabb1bc2a72da08b847141bc62eaadad45430a7a"
  end

  depends_on "ruby"
  depends_on "xz"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
