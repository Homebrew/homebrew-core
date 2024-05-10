class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "4be6932a97da0e36aea1c6cffaad559caea19f4948dcef8dc1686d5c2e0d3045"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "810ed3bd079fd42cfacab17330fe2d707decc3917836248d5f4b7a9419c20a38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0f7484937e4bca9c64007e913074938c4b753110cf9bca621e0e45142303cdd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aff036b4aecb96fecf1581aeeeb800d041558576dad2440a98cbc20b7bd1a671"
    sha256 cellar: :any_skip_relocation, sonoma:         "5956704eb7eb984a84b30605d5aead0adfc2c5b4d0c083590c3690ac94ee4b12"
    sha256 cellar: :any_skip_relocation, ventura:        "225484988678fa554198ad46727ec5e7e612525f471a2e99df1bb741e582e65b"
    sha256 cellar: :any_skip_relocation, monterey:       "870a7e68774aa1f14354c69e5340093063cbcff85467f047d507a7ec9b987b71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04e826ce0c23065b862323444bd5d64d6cf847c0014fed4d6e7170ef55ab1fa4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    generate_completions_from_executable(bin/"stern", "--completion")
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
