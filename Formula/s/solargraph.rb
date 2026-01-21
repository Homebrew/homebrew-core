class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.58.2",
      revision: "676da4c4cec040d735a9a54265c91dc91ec462bb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de2b5ae2215048580bee20fcf06f997308802199b744b0f1044577eea79ddaa5"
    sha256 cellar: :any,                 arm64_sequoia: "41a456516443f9280bcbdf08ee6bc5369aa5d31b4f4f56f1a5b85e8d4d81f7d6"
    sha256 cellar: :any,                 arm64_sonoma:  "20c3023c9fbfbf468e1bbb37abceeb6373244155b2759e01cea255c8e4deaa1d"
    sha256 cellar: :any,                 sonoma:        "1ed7f4fbdecf7262acffd74d020a188616f0cf36a0f89e93fbc2d84bacc70e58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90ab5950530d16e54f51ad731ce5235b2b187f749a02afe7891a39b4cad713e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70e8460037225569d5269a99511eeee2dd0c145ce41caed6114bbb8a6f83c356"
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
