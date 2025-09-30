class Trdsql < Formula
  desc "CLI tool that can execute SQL queries on CSV, LTSV, JSON, YAML and TBLN"
  homepage "https://github.com/noborus/trdsql"
  url "https://github.com/noborus/trdsql/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "e3b8bef57330648d3f4b279bd4c652eaeba19aa4fae3fe05cfa596a2b3f4bc51"
  license "MIT"
  head "https://github.com/noborus/trdsql.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9ddcc05dd7ac0be0fe6e20e1881ee61ee15db929558e968a914c8a1c032bbe1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ecd934194fed8b8fcb0c00cdb3108e5a4bf9ba7e465c13f4e14e9a864ffc0a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f998e6d2c9f7085a17395d4b3d4da1065bf806139a03a5dcd99054dcf8071d88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c3a2bd0fe2bf86949101930b1efb4c280a52756d59f69b3f04d0c8c612dd415"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dc4cae00a081d54f378ff91ab8b3b80c538063efec0633b11ce0e24c4dc64e4"
    sha256 cellar: :any_skip_relocation, ventura:       "bb08c8329af1c57cdda3d50b3d685274c45835665a9d91bf7db15caf01d5c19e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f84e77253c3cb7ad195e7e3dae37b9981e018aa6bc18be292566f433efa7c07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcfdc24169094af5142de81d1f342512c639c262bc8f10566e5ee5230ae6a2ac"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/noborus/trdsql.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/trdsql"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trdsql --version")

    (testpath/"test.csv").write <<~CSV
      name,age
      Alice,30
      Bob,25
    CSV

    output = shell_output("#{bin}/trdsql -ih 'SELECT name FROM test.csv where age > 25'")
    assert_equal "Alice", output.chomp
  end
end
