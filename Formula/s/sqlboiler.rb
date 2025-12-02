class Sqlboiler < Formula
  desc "Generate a Go ORM tailored to your database schema"
  homepage "https://github.com/volatiletech/sqlboiler"
  url "https://github.com/volatiletech/sqlboiler/archive/refs/tags/v4.19.5.tar.gz"
  sha256 "fae160e36637c5d0c57db53bafc11439cf61b02dc30656277d7e90c546b04a4d"
  license "BSD-3-Clause"
  head "https://github.com/volatiletech/sqlboiler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca1a271ac90407aecfc61bcc31c43f5943985c5785817f916279634570b3670a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24bf4847e512fc0c4987ffb7aa9731270eb83642f874cceac6e3163be7ac7da5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24bf4847e512fc0c4987ffb7aa9731270eb83642f874cceac6e3163be7ac7da5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24bf4847e512fc0c4987ffb7aa9731270eb83642f874cceac6e3163be7ac7da5"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd3b13555a393652a4f08d29c23239f57677db9f1ee7d451107ee660ce4c1aa7"
    sha256 cellar: :any_skip_relocation, ventura:       "cd3b13555a393652a4f08d29c23239f57677db9f1ee7d451107ee660ce4c1aa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15045ea97a8c55564a5ec41422248e32ebfcd7b7144b1201106135f408dc1890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0d778d654efc38ee84e8f54d3a75a2286993a13c0ea8a5b28d160defa6367cb"
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
