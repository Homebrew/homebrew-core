class Rbw < Formula
  desc "Unoffical Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.5.0.tar.gz"
  sha256 "a9e8f6936564aac32b6d9e701339a9c33ebc32b97560e72325b7ca4b14e760bb"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f409832baf1488b2b5a557e85889220db7960739a905b90a752944a192092d65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34564680f7a2bc2cc130ebb20707b173ee4754e4681b49d12a7e042c1b0c1edc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69a947b346dc757630773de4c6214a9d6ff8d8f93f4bf5f6b3b832acdde2280c"
    sha256 cellar: :any_skip_relocation, ventura:        "6afc05c896f43098a2038057aaba11e53ce713175f29888749645b2a21e1d689"
    sha256 cellar: :any_skip_relocation, monterey:       "ca8d9ceb7cad60ef36fa68483d66f10931d5fa89f8271fa96cbbc4a98b084a69"
    sha256 cellar: :any_skip_relocation, big_sur:        "f95bac15a4b67d7df0eea5fd7427ef60134d502d351c75921f22d44d5b046bdf"
    sha256 cellar: :any_skip_relocation, catalina:       "bc8a5b52d263a430c63cde66964108e8579773866fae16f17fe40abc2aee65ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d4ea418fbe435f6d87fb7c7ea843978fd4c1ad1be770ba7679ecc4f4b9f2910"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rbw", "gen-completions")
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}/rbw ls 2>&1 > /dev/null", 1).each_line.first.strip
    assert_match expected, output
  end
end
