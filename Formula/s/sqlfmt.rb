class Sqlfmt < Formula
  desc "SQL formatter with width-aware output"
  homepage "https://sqlfum.pt/"
  url "https://github.com/mjibson/sqlfmt/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "0776e9505048fd88220c0ee9b481ca258b6abe7e7bb27204a4873f11e1d7c95b"
  license "Apache-2.0"
  head "https://github.com/mjibson/sqlfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05c503eec0cd5a79c9cc3e1027166051acbf6f2a44d2924cadb9898b4600ceb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d6d1bff83aa71623e857ddf1f53ae033646e5bdf71ec1d283fc1d344364d3ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae54cf2b56248564f43b4ce61add06377a564115314d8c524892572abbc1c3bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf05930ebc73ec4e027c7463a3e8ceb327492d32d2e32ad7c571f381fa9e9bc6"
    sha256 cellar: :any_skip_relocation, ventura:        "f6b9b8a8849278f597ef6b98f8cc6868b0dbda0122207dfb127600aa36a4e60c"
    sha256 cellar: :any_skip_relocation, monterey:       "18c12379256a1d5d2e659824951ed74e49c73417fea49b58a5c0814cb74c78c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3d79be793a67b641b58cee79ed6da1320b6d4ed2cd007d500e5e9ad26e70378"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./backend"
  end

  test do
    test_sql = "\"SELECT count(ID) AS count, foo FROM brewtest GROUP BY foo;\""
    assert_equal <<~EOS, shell_output("#{bin}/sqlfmt --print-width 40 --stmt #{test_sql}")
      SELECT
      \tcount(id) AS count, foo
      FROM
      \tbrewtest
      GROUP BY
      \tfoo;
    EOS

    assert_match version.to_s, shell_output("#{bin}/sqlfmt --version")
  end
end
