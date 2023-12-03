class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.12.6.tar.gz"
  sha256 "c0645665af8393a0432539e0019a6ad0a6416af0e8ed47ddcce019af3c7c5e15"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29caea397120e5f21233fc0378e1800f0df26ddb7f871f8a091f76cafdefcd62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40bab430022149a2a6745fd6e4a33f25bf1e85279c26a35a426544078ba9d7d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2c5aa3a0ce02761fc7ee9378c27d0c2385d01565180b92379bc5fe8f71e9357"
    sha256 cellar: :any_skip_relocation, sonoma:         "46db625450f3203a343fe791d9401037ff734269a0306f6094199689fa4915f3"
    sha256 cellar: :any_skip_relocation, ventura:        "5190c317ed3e637cfa5cd87a361064d8190e7bbd78d95695bc4183519371d446"
    sha256 cellar: :any_skip_relocation, monterey:       "56933a3f6c6c3f63c6f45840cd4cbd9cac75b6f6ce2f2d3a2b73a00973b19b77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7213ba1f7b8dfac7f36de4ae404c02af48c3452be296b9cb62b2863edd479ee1"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
