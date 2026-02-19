class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.58.2",
      revision: "676da4c4cec040d735a9a54265c91dc91ec462bb"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "a47d973a60f7b0c90ca64c2f5303dcb715e15b6a67016d5e5c8c955b50666dde"
    sha256 cellar: :any,                 arm64_sequoia: "21528962304ec1ce311d2e8ef81cf6e4c7ed2110ba05b3850f67b0c16cb5ecb8"
    sha256 cellar: :any,                 arm64_sonoma:  "206c61bc651b6e8c3dda0186ad9eab6c670d916e4651a26e1eb65c83532f2a49"
    sha256 cellar: :any,                 sonoma:        "0f81ef3e92622a05e4f5692e83f1054ce69325b5054ab44e06f6dc068c42cd1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1b6cc76947d67660a41908885f04641d3270faff30f1bdb08c0bc27f35a4ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6984aa7b9a852f661621069b3c461625581a2003bc8820de98e086e36652d33"
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
