class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.58.0",
      revision: "d08a25d516bc62d3bbc0c26934a3dd2091a26b8d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d9b731624f489ba76c2e4bec7beb28f1ac61a41d7314cdeba10a54fb9b70a06"
    sha256 cellar: :any,                 arm64_sequoia: "e737706a9fe627651f91c71c6efda3ee3dcd14ea3de7b870c464dcef186753a0"
    sha256 cellar: :any,                 arm64_sonoma:  "bdd0c35eb0f1d07bde5cb7e5766d9efd3611464495343db2d016fdcd82cf46cf"
    sha256 cellar: :any,                 sonoma:        "b703f1660d334e5a98a060ff2504b4602634e1f3b3c3db988ef1e03f6809e8b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "670de85319c83ff3e8ef57d54c1f3117fcd164a43babc246464f363b07e20cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4448991745fb6c75aaccf2403d84224ad41882bbcd9e675af4b87d6e4669b388"
  end

  depends_on "ruby"
  depends_on "xz"

  uses_from_macos "zlib"

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
