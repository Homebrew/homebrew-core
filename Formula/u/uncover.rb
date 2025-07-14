class Uncover < Formula
  desc "Tool to discover exposed hosts on the internet using multiple search engines"
  homepage "https://github.com/projectdiscovery/uncover"
  url "https://github.com/projectdiscovery/uncover/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "63858b248a5e5729d2887a080359335bbf435965bc8c75acb26b377ff5db98ce"
  license "MIT"
  head "https://github.com/projectdiscovery/uncover.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e53b9641ef3ca32670c2beef2889926f5dc3c1a24a2459b80c9bda3383a4f280"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a544836a98e20fecf8aa7668c32794faf19c83ad2470479458e18b2e48e2873"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e642d0ab1505914cf21378ae8c161c7469ffbf4532432661a8675e6765d0b4a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfcfae2e612eb6f1ff71ef0b884b733b8df6ede3e153966c53bc94cf68f075fc"
    sha256 cellar: :any_skip_relocation, ventura:       "409b4f658ad90217918b7313aca3d9872695102447893881f155c06b7328543e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "066f5b2749c79734de3ec2d3f913f03230c331866ee199cae9557e26cbcab221"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/uncover"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uncover -version 2>&1")
    assert_match "no keys were found", shell_output("#{bin}/uncover -q brew -e shodan 2>&1", 1)
  end
end
