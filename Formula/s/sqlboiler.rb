class Sqlboiler < Formula
  desc "Generate a Go ORM tailored to your database schema"
  homepage "https://github.com/volatiletech/sqlboiler"
  url "https://github.com/volatiletech/sqlboiler/archive/refs/tags/v4.19.7.tar.gz"
  sha256 "b6e3ca096750ef7f917a81045d779126985c5aa68e3179746e05e8d108e9244d"
  license "BSD-3-Clause"
  head "https://github.com/volatiletech/sqlboiler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9da5bc117d6334b1e04bd17a1a5fcee72fb506aa0d7fd821b2ba79a3b579f9bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9da5bc117d6334b1e04bd17a1a5fcee72fb506aa0d7fd821b2ba79a3b579f9bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9da5bc117d6334b1e04bd17a1a5fcee72fb506aa0d7fd821b2ba79a3b579f9bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1c5f8a9bb11ea5a4deff6ca86985d488647dd03978382912ba8bbf340fe69c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7d17c535299cdad709093d4dad12bde1b6b1a84b85f4517bfb927b97c6e6115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02355a4d2f91c2068f54cd28f5bf09e80b164c558bf943bf1111feca994a0eb7"
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
