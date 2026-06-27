class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.60.1",
      revision: "6d003d6fe8fedbf157d707f0b1cc6350f61b9190"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "95e8986026ace62d764712675649874c531fef024d64c6227348437082ea529d"
    sha256 cellar: :any, arm64_sequoia: "0a107280f6094126e4d538cd778cff362da8bbd22804dc13ee833307467ef0d0"
    sha256 cellar: :any, arm64_sonoma:  "75da94a9b04aa535d2f14dc3217c1d6c2d9ef24154bc12797be10837b296069d"
    sha256 cellar: :any, sonoma:        "497416d2f11a521a8c5c5f8de464363e3ea0cfd236fdd624bcb850bc718f7214"
    sha256 cellar: :any, arm64_linux:   "2b35a23e1e826f69d14b4526bce7d0b06de34c12b18fbe82d81efae225fe2e2e"
    sha256 cellar: :any, x86_64_linux:  "3d31176fdecf5f054cab4d893fb044f2a877ce386457a3a09dd855f6ccbe8051"
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
