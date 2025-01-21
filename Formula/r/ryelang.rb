class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.34.tar.gz"
  sha256 "cf1959ee6742b98aa9dedddbb3dbf5783892f48e98087746cb3bafd7b53b0456"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94a288beed04342c1a5198d1acfd7fe0d39ee6195d9e3038e2d19c6560712e8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0264508588085dc93849d23c8e4b16f6b588535266eecd35cadfc4c969603260"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f078e5b9a48984b2d750a9935ee4510c8b1911bff41529b0dae923b2d0248cf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "d82a9f38c8866eed9b29e5d824bcee12805c300436f2d693b92c4bb9ec8ed963"
    sha256 cellar: :any_skip_relocation, ventura:       "f203ad38869fee369d18cbd52154039ef42a7c4736a4df78dcdbaa0b6890c14a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a3b8c9851063409d4028a1be98b33345bea7bec185e8783548f8ac344e57b35"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_predicate testpath/"hello.rye", :exist?
    output = shell_output("#{bin}/ryelang hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end
