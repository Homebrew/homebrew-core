class Shuffledns < Formula
  desc "Enumerate subdomains using active bruteforce & resolve subdomains with wildcards"
  homepage "https://github.com/projectdiscovery/shuffledns"
  url "https://github.com/projectdiscovery/shuffledns/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "f1a067b81980c57c9c024aab5988c78cb93159312d6fcf5c2ba0fd6b46d6f4e0"
  license "GPL-3.0-or-later"
  head "https://github.com/projectdiscovery/shuffledns.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "169bd116ca2c2ded412843dc7bc8ae58c7d80fe88dbeff1e4b921bd689d94d11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cc57e03bc1578d038f038e61732bb6792218b0f4ded826f8c121434fc968cce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3be0efb8a70e71c1d14114e32377e8edddc0b1b5d8c8990da0589ad6388820d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "defb16f81861103feb5d35841c03a1bce871e490754cc688c576737977879aec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e8c9e9fabb9c728dbda633cd189d0a8c33cc1a568b67cbaa6b97c3932cf235d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52df73fdcdf19cf5244cfc9c83d934681e7491a153c1ae98d94fba7a7cf33836"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/shuffledns"
  end

  test do
    assert_match "resolver file doesn't exists", shell_output("#{bin}/shuffledns 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/shuffledns -version 2>&1")
  end
end
