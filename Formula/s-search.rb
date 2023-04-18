class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.6.7.tar.gz"
  sha256 "a175e53e2d9c3b990a963b86b285a258ca5533c78fc930cd01b82f4d9dccfec0"
  license "MIT"
  head "https://github.com/zquestz/s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67759e1e650bba6dc8ccfdb8e1e0697f1c1d6910b40a99a89d320122e24d4ce6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "965829bd245fca1aa157fafc92cc1fa1e30119787ada98e206a592480dfe54f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b045c12f55145d21f9e8ff8d2c4fa4268e8da8ca47763d3dcb1bb2cdb5d1198d"
    sha256 cellar: :any_skip_relocation, ventura:        "a34f71eb66e840d0ab3f3cde5c816f2de7c39cb29b3917ee47b0a4ed4055f730"
    sha256 cellar: :any_skip_relocation, monterey:       "6d02733b5bed8e5fac42cbfb68bc7f62d05b54189b64309f3ee6780030f61194"
    sha256 cellar: :any_skip_relocation, big_sur:        "701c54566cb83d362852e8b4ad1232ad753dec1ac9385822f0e260fe6c2306fd"
    sha256 cellar: :any_skip_relocation, catalina:       "e800f781a6c125be3eec11e4a204a3cede538e5381f040f2f2f126fc869b1a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba3a78a32f8be0b79d44b695ee4b35dc0563ecbf29952035d28df0445c87763"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"s"

    generate_completions_from_executable(bin/"s", "--completion", base_name: "s")
  end

  test do
    output = shell_output("#{bin}/s -p bing -b echo homebrew")
    assert_equal "https://www.bing.com/search?q=homebrew", output.chomp
  end
end
