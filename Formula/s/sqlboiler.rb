class Sqlboiler < Formula
  desc "Generate a Go ORM tailored to your database schema"
  homepage "https://github.com/volatiletech/sqlboiler"
  url "https://github.com/volatiletech/sqlboiler/archive/refs/tags/v4.19.1.tar.gz"
  sha256 "ba6fb59dcf9fc6ab14223a001c5d53156165563cb357521eff0e599eb61cef2a"
  license "BSD-3-Clause"
  head "https://github.com/volatiletech/sqlboiler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08857ef511f690f8933d95b76105661e7649530a646684d723735191f57435c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08857ef511f690f8933d95b76105661e7649530a646684d723735191f57435c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08857ef511f690f8933d95b76105661e7649530a646684d723735191f57435c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c69916334c39d17e4021dcb5d934d83fea64991a77819bb58576296e2d3ebc0"
    sha256 cellar: :any_skip_relocation, ventura:       "9c69916334c39d17e4021dcb5d934d83fea64991a77819bb58576296e2d3ebc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "864792653086ae9530164a4e60696fde39cafbdd1111e048a51e6ca5ad119f08"
  end

  depends_on "go" => :build

  def install
    %w[mssql mysql psql sqlite3].each do |driver|
      f = "sqlboiler-#{driver}"
      system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/f), "./drivers/#{f}"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/sqlboiler psql 2>&1", 1)
    assert_match "failed to find key user in config", output

    assert_match version.to_s, shell_output("#{bin}/sqlboiler --version")
  end
end
