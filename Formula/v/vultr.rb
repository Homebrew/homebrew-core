class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://github.com/vultr/vultr-cli/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "f979ed556bf55c0cbd4cd9aa6afd8a4c7a8a6a34414bbaddc039b294d25dfac3"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c51f13b2a3d1d291f8b3a2ffea5fdd69f886c8cd55a5aff174f4da1ee186c73b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0e645315772ad8b40b6dc18bc59764cb1cbd2e3f38bf5ae6677b637577a8048"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e58d01dc0826d074957d8d829ab1bab51ef9bf21045d2b0f51c80be3eb99fe6"
    sha256 cellar: :any_skip_relocation, sonoma:         "68b57242c0de721899561543095be357465460e9c268b03114e8846f9e111ae0"
    sha256 cellar: :any_skip_relocation, ventura:        "05612184c945a091d1327d118ccafc0452a582672dca0dcce9c2991b77dc9d85"
    sha256 cellar: :any_skip_relocation, monterey:       "76c0a649a2b0e00949a6779680831e709a1001b33aacc39b674ed5244ff9e0dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a16b1ae0792e775c5d6615347bb088215177dd3c03d57f73fea43ae8c279498"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"vultr", "version"
  end
end
