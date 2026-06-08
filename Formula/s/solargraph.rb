class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.59.2",
      revision: "43f4caa0da9415db37454ad9b9b3f992e9a3bec4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f853fb4120700406eecdbd3deece1578a441d79e9221dc65aab7a21f2d7bae41"
    sha256 cellar: :any,                 arm64_sequoia: "769a8e12841f02c4afda6d29e94a6e731597a08d5c2585f000db46d8aea902cb"
    sha256 cellar: :any,                 arm64_sonoma:  "014cc0c1d6f9c4706b3f8d1d0f08d30aeb0953731077b99f1be10a80876253dc"
    sha256 cellar: :any,                 sonoma:        "e041d57034c67a153bb22ab5ba4d6523fc2be18a5564bf94596cb93d911087b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e8c10babb05ca1a8b759b1ea0dd6e6c0691ba43b02d9852439f0706745f0c89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eebd1b8c298c073bd46cc78031f89de2a39a4314d6c8908aa422e77e4ccfb077"
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
