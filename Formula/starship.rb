class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.9.1.tar.gz"
  sha256 "2b54bee07bf67504a1bb170d37dc8d6accab4594d35731bbdf0e8a631c8d1585"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71c94041630159e74d5778d63aff52e6ca37c5c72bd9fec8210defb303a15775"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e405f5a2ebb6bf494bf6ac2e6848787dacacb2ba2318d0e5bda2ad52f44594fd"
    sha256 cellar: :any_skip_relocation, monterey:       "560e6b0b6897cf2cef0eb17ee228436011739ff46551f5173de661fdcb91ee9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa029997e1255728b0abe6b5e3173ca1cbfc7405f48ecb5a94f6e60e7caed169"
    sha256 cellar: :any_skip_relocation, catalina:       "8be90a68173e7a9dd2263142a9591736da7f486ab13572c17b55d87521e23004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "415f8ec29ddc7c7b6c7152ae076bd64a26912d709906e5fdec3ba3285b2ce120"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"starship", "completions")
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
