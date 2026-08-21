class Skeema < Formula
  desc "Declarative pure-SQL schema management for MySQL and MariaDB"
  homepage "https://www.skeema.io/"
  url "https://github.com/skeema/skeema/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "3c38cbf5aed5dccce918da3fab1be97bbe21ae3422bf74deb9cf40529e1b84b1"
  license "Apache-2.0"
  head "https://github.com/skeema/skeema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51ca8e90dd79f58b6d91205fc7119eb6fa602a6b40ec776a4acd66a464e85b4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51ca8e90dd79f58b6d91205fc7119eb6fa602a6b40ec776a4acd66a464e85b4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51ca8e90dd79f58b6d91205fc7119eb6fa602a6b40ec776a4acd66a464e85b4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d24e03a3c4c65d119f543dcea28cb1e747a7efe5f044a3c18b80d74d65bc6ea4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19e977df5ef110a1b97291f74cc5202ba89e025fb514f4ce8bbf829cb1a23d1a"
    sha256 cellar: :any,                 x86_64_linux:  "2fd47fedb6618da28d12b45a419fcd514a203361553e566084190c9b04d8fae4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "Option --host must be supplied on the command-line",
      shell_output("#{bin}/skeema init 2>&1", 78)

    assert_match "Unable to connect to localhost",
      shell_output("#{bin}/skeema init -h localhost -u root --password=test 2>&1", 2)

    assert_match version.to_s, shell_output("#{bin}/skeema --version")
  end
end
