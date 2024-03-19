class Skeema < Formula
  desc "Declarative pure-SQL schema management for MySQL and MariaDB"
  homepage "https://www.skeema.io/"
  url "https://github.com/skeema/skeema/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "3da0888c67f90875e8c086f4f965965055d5990fb152359a4c898837cd7d0c51"
  license "Apache-2.0"
  head "https://github.com/skeema/skeema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c8d149fa3bbdea602c3a4821aba1dc222a78bf66f52f4dbf11a995e9c7c7866"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25f9567f154ece2572105febc487bccb731061837262c2ed3a3412459897c411"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73d16e14822dfa2d1cc1609438da9e6b726fde73fd3a73abf935aeff6cd1d2b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "4079c995723bc64e9e323f44ab429e4cf16c8b205bddbb50b230fe7571396b11"
    sha256 cellar: :any_skip_relocation, ventura:        "c910909cfb638a2b7ddf2a5fc73c1ee40cbb2a05770df7cb6002b2a7a00baf7b"
    sha256 cellar: :any_skip_relocation, monterey:       "f7fe7077a5edc43df38a0fe3f2dd061fc1050352b78685ce6de7102f8dc6c7bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0514a6ec7a8a8babb8ecba59ba03cd9276f126487c80a62cbc83bbd8e2e72748"
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
