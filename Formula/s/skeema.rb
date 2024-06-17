class Skeema < Formula
  desc "Declarative pure-SQL schema management for MySQL and MariaDB"
  homepage "https://www.skeema.io/"
  url "https://github.com/skeema/skeema/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "44fd48b35848440dc6d8deb8f812e8492e55dfa987e6ee3d697b3e8bbbac63c9"
  license "Apache-2.0"
  head "https://github.com/skeema/skeema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04a792515581d4dca243771c591d1c08e465730c3b8defafd19f5530cea3ade4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffa781318a9cda0301b6fc55edca3d4095f615915d11a8274cdbff63fda7bf5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34c99b470c869a7bacf2876c4dc75c5b9a6e6dbf33a32a44809bbdcae29f8d76"
    sha256 cellar: :any_skip_relocation, sonoma:         "710e18e5fd2ba7b9b55a6e438fa711fed1492fae0b6d613b89e1c34f78aaef8a"
    sha256 cellar: :any_skip_relocation, ventura:        "8576f64d0ec0e4a4b90f960995621880fa58ad99889d615b2ad59bf2a9c895a9"
    sha256 cellar: :any_skip_relocation, monterey:       "234a47d60d3b75dda812c514418557da7d080a8f07eb8a7d3c6a582c04f1285d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaefcfcd76a18972b81adc5de2766181dfdbdb39b3fbe6f0259779bec8518976"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Option --host must be supplied on the command-line",
      shell_output("#{bin}/skeema init 2>&1", 78)

    assert_match "Unable to connect to localhost",
      shell_output("#{bin}/skeema init -h localhost -u root --password=test 2>&1", 2)

    assert_match version.to_s, shell_output("#{bin}/skeema --version")
  end
end
