class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "e760cea3985f4029501a4170bf33d6dd5d4ced6414ee9b38910efdb34e514cb8"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "877c6243c7ccff35c311467be9799229ac49789c8e5fc0583abbfeb8c0c96a6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aead350933a8df28997197aafb379f0faa8730b730dc0173cc1a72c21b621bf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d23462edd2614b99738e327c4b7e472685458130f10357d66939018a667343ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "60b80df29dccb1464d05b245c3f48857d0144c5b8c8aaef955dccc5b821fa392"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a04727b7f84b6bf8377d649f12486a4f959e455804c631eac9b452417d77ebca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb42c7afebc943b3a1a853626813e799f10e78ab19e253f2b78a3f40e117bdc1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match "usage-cli", shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
