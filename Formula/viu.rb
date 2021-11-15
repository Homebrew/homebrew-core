class Viu < Formula
  desc "Simple terminal image viewer written in Rust"
  homepage "https://github.com/atanunq/viu"
  url "https://github.com/atanunq/viu/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "ee049c065945a528699799f18de4d82355d5b2f5509d2435b9f5332c8dd520c5"
  license "MIT"
  head "https://github.com/atanunq/viu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2269576ed41f39754a5a19c14d683d6cb49a3f542ae2c01f5ed4bdd407f4e0dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2522e8aca392e56f1517b092a8091bd3ba5c4ed45220fd92e4daa79240ee4182"
    sha256 cellar: :any_skip_relocation, monterey:       "3a6fa60f802de0598b653d7625e94a4208e9f66820a31749a02b45f376e95106"
    sha256 cellar: :any_skip_relocation, big_sur:        "572858e897b2e307b45e02d6814b4e562682554bfaab4c1a827cbb07b679ecf7"
    sha256 cellar: :any_skip_relocation, catalina:       "0029a7093ea3cf9e65b8eaa168ace9a0c424dced8ca233bcb74a67139be10277"
    sha256 cellar: :any_skip_relocation, mojave:         "051cee6ee32390448b48ba56e2e9d60be22c6d9b43687f3713482d9e3dfe6017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06d513576fa431015bbc55fd6d118aff7be75a6fa468f5a42ee567439442cb16"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected_output = "\e[0m\e[38;5;202m\e[48;5;202m▄\e[0m"
    output = shell_output("#{bin}/viu #{test_fixtures("test.jpg")}").chomp
    assert_equal expected_output, output
  end
end
