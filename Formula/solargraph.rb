class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.47.2",
      revision: "12fcf71755db2d570f591de773753eb73ac0680c"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "eb394a038814059cb56b106d198daadc2b8e958300c5f2170de79bfeef2046fc"
    sha256                               arm64_big_sur:  "f3b5f115be6fdefd43ff1cf26af3fb6cc187404655be714dde26b05782582436"
    sha256                               monterey:       "b9be3a220b2db03185fb4af00a2f2645771c7c24b6c694994b925a14ad3b9109"
    sha256                               big_sur:        "9fe41ba652f9df2a509b449f241c20836a9acd72e1b3d05982e2709b51e35f32"
    sha256                               catalina:       "50ad7b82737cff336eb045ce13aa8826ea3b475d46c9960a5021dcbf681e1b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33a3d8c60bb04a775c402ed91f323b919e13c7115cea06d115c0373c19f50c48"
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
