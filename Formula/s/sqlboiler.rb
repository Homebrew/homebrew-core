class Sqlboiler < Formula
  desc "Generate a Go ORM tailored to your database schema"
  homepage "https://github.com/volatiletech/sqlboiler"
  url "https://github.com/volatiletech/sqlboiler/archive/refs/tags/v4.18.0.tar.gz"
  sha256 "dcbbeef8c077a8b988fb5750fd6d334f3fddec86ea679f1071adaf82a67b2298"
  license "BSD-3-Clause"
  head "https://github.com/volatiletech/sqlboiler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1abb342fdfab30d9d143054acfd4979cd0134681602551fdc7170f5a86f8815"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1abb342fdfab30d9d143054acfd4979cd0134681602551fdc7170f5a86f8815"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1abb342fdfab30d9d143054acfd4979cd0134681602551fdc7170f5a86f8815"
    sha256 cellar: :any_skip_relocation, sonoma:        "42e35b08b3485f333406d5edeb2ac24a754586d75e9f43216c1611d2c816b84e"
    sha256 cellar: :any_skip_relocation, ventura:       "42e35b08b3485f333406d5edeb2ac24a754586d75e9f43216c1611d2c816b84e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d976fe8334514b6c20222fab1f021e5d90807fac14589c53ff3cea4516f9a1d7"
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
