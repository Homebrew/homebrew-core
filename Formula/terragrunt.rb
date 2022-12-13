class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.42.4.tar.gz"
  sha256 "dfc8f71c2337180b859c6167e7a86da9c93a281f40743808677318aa1409e0f9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52feb1e57fe592e3a7352d0d9be9788afb05f212f84847fe5b2440cdd9f7f96e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af45dc7600480b4feff1e7ec63c1e3ec4bdd5873ca0e458c0ce805ae70f62cb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82d8f02cdd073a6c68c14b4da19a8d7398da624cf1e81b077365df0684a365a5"
    sha256 cellar: :any_skip_relocation, ventura:        "fd7fb176b3901dac10ca22599187c0a95ce2c7cd132562ede4f554d501706b32"
    sha256 cellar: :any_skip_relocation, monterey:       "728b79d8ed838d79687c75f54a0c9cfac7838d2983b0677a7ed21bd814dabc5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6fa122c0a6b655971c1940bde2091ca84c76a5cb759ad406456e17253f29aef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7da0941a7a3c5b207ad973ad4b6dec1a91fd81d45ca1ccb0d21d7efa0b2cf99a"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
