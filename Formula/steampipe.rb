class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.18.6.tar.gz"
  sha256 "828661a68d85169a80353927c86546a66a27b9fa8eca376ec6b90b86cd47252f"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4c367fe043be768f616cbf9620cd663d8f657e9f61104e8bfbf64260dabe046"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af4429a0d1d119e52e9a9a0d480eaea90828c952ea1132f958c6250a5ef1df79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26057ca454f7ed174e0b67b5e04c9fd52857444d0cffd25b6a318669c6076bd3"
    sha256 cellar: :any_skip_relocation, ventura:        "41801839972014976762669faf62c9f0e4c675214c1f66d663ba94495eefb608"
    sha256 cellar: :any_skip_relocation, monterey:       "4ae2ea9074c150f9c2c52c3608b16a53482e5832793e64f34171c551c265349f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c326b12e334759d20e1ee0af809b35aa3c12283a94480e030d0485c9b5dbd1fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecba8849e9c02516c2fd0de02f93b2341d70289a3f623c1718aec9869f53e2fa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    output = shell_output(bin/"steampipe service status 2>&1")
    if OS.mac?
      assert_match "Error: could not create installation directory", output
    else # Linux
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
