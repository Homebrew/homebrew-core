class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "7885b74ea8e62d3156489888a01e30b76f1e5e65aee63b11232b968fce37d3e8"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22ba11d21bc3c30dccf18583c181cfc3c2163d7a598177541856d682fad8cbca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90e489521c3f1fd54fbede6e1fe5367d0a4420dcd11c8b3aecf9ecd9fe9471fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "526951d476993b4bec51aa0c6fe46fbb22343498ab3cc512051f671c938aa0c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6e7bd2305425268fbfe005f8a581fc813d51d1df045a928d6438a28094557e9"
    sha256 cellar: :any_skip_relocation, ventura:       "f274d6cf063b5c38858c46b72947e7d01b2ccda7060b9716884a0ee47c5c2383"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6cdcc22124033c1903f4080a8c355036013c31c004c587e8a3a99d59a968e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "247257484f77f0453513c216656f23eb225fcca7be90f3f946bf6320c456c2aa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").strip
  end
end
