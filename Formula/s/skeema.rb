class Skeema < Formula
  desc "Declarative pure-SQL schema management for MySQL and MariaDB"
  homepage "https://www.skeema.io/"
  url "https://github.com/skeema/skeema/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "a29c42436967b61e6a5b1475b0166e38583c7f0f6381412409d76eaba9cced7b"
  license "Apache-2.0"
  head "https://github.com/skeema/skeema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbcc88c91395e39c504ee1ea7fe2e9ba1a2ff731d17281209b2131df8cf8b247"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbcc88c91395e39c504ee1ea7fe2e9ba1a2ff731d17281209b2131df8cf8b247"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cbcc88c91395e39c504ee1ea7fe2e9ba1a2ff731d17281209b2131df8cf8b247"
    sha256 cellar: :any_skip_relocation, sonoma:        "02a449d113eadd1c3cc6fc6bb48460b0d01b13166c929f01720c5837d7b99794"
    sha256 cellar: :any_skip_relocation, ventura:       "02a449d113eadd1c3cc6fc6bb48460b0d01b13166c929f01720c5837d7b99794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a148cf88c9e449ce572fb8db7441c42a6205968be27f170ed1ed431fe5c1cb36"
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
