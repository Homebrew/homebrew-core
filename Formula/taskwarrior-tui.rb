class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.10.0.tar.gz"
  sha256 "e6f9489dca3cf6d4465221384c3ff25950ccd1ee0037b65828888c63dc17c035"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d5a2beafbc39a8bbd17fa42406c25d163e3cd2c03657761ee43be6039d57ef28"
    sha256 cellar: :any_skip_relocation, big_sur:       "cb941da6513d30bfda74a29b9a73e4991c3068cf6693bb0f5e9abd89216de0e1"
    sha256 cellar: :any_skip_relocation, catalina:      "258f91093cca2920222294804c445a255a39fe283c56ce8f61998cef288b4f52"
    sha256 cellar: :any_skip_relocation, mojave:        "cf29d9eccf25a0d801ecdd9412e64130b86c5f86c5b50320c576fd0d59e26b2b"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 1)
  end
end
