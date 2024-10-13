class Sqlboiler < Formula
  desc "Generate a Go ORM tailored to your database schema"
  homepage "https://github.com/volatiletech/sqlboiler"
  url "https://github.com/volatiletech/sqlboiler/archive/refs/tags/v4.16.2.tar.gz"
  sha256 "18f5f8d6440e9f61e5f6de81b014db7be59b2156a0cd81bc721bb9c3fdc0ddbc"
  license "BSD-3-Clause"
  head "https://github.com/volatiletech/sqlboiler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6f759cd888c85871333bcd1085045c261371523abd65cbbd32a38c8172c23a8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8a10325fdfb7fa68999dd6e469e48b74d50641148a07da4505994efebbbc8a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf85c025cb7b30284ea00c1a7bcc0fd9a2e995a3374d027ea717cfc6f6d5bf98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0730d42769f760f1b51dabb7f5dad6f37606dfab87a8a6d8ad31d7f31775f16"
    sha256 cellar: :any_skip_relocation, sonoma:         "732c6fae0fadaaa51a80e33350c39e0b0efeec39fde51a87fcbeb7839ef6d577"
    sha256 cellar: :any_skip_relocation, ventura:        "f64783e957da7ebd081d351d6f082cb1eb79f1b8c08819334022f22fc155dc74"
    sha256 cellar: :any_skip_relocation, monterey:       "b0b6265bc8b76126336b657514b49e2958905e74a852651243d2d2cb2ce92186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e34ce15ae9aa6b89e29522c06c5a4d50fb8f5edcad8f8d6e19ce20cd814f1a6d"
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
