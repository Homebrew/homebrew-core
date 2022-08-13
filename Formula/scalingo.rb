class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.24.0.tar.gz"
  sha256 "0bc043ecc6f8b536800d7cab2974addec2737d51a80c4cef020bc47f82a5f7f2"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5a0e3b420909672bfde6202ea8f902e27c301cf4b061665348fe49b1827ad3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11feaa55e63f384b4a857d1ceb67d47b416395ba87ed2ac1af27413a2660f6f5"
    sha256 cellar: :any_skip_relocation, monterey:       "c27e918356bf070f4603bcc77848e9e90e7b724ba1595ac55452bd6a63f148f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3a8476fb58c11166772676234f20c59d1ad7d25767351f2f6145b303ba18575"
    sha256 cellar: :any_skip_relocation, catalina:       "54fc09c7af7cfb0fe439d7103c96e7419970d1d658e9ddf28f567c453ca29606"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "554f2af13e91a17050f4eb3ea43fce4d96904d152b193a6c68b91fa577cae25f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"
  end

  test do
    expected = <<~END
      +-------------------+-------+
      | CONFIGURATION KEY | VALUE |
      +-------------------+-------+
      | region            |       |
      +-------------------+-------+
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
