class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.16.0.tar.gz"
  sha256 "035f3508ad3954aa1117f662f9f59541e7a0059483b15d573a8146d997b54827"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9b443cab6df437394b07edd2f3b5d0d156061faebac570a1b913231c617cd92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8698432271512ae4822f764aeb3981c4700482557a5356bedd68f82c6e49dc81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a64951157d2cf3b3e357336037ae06de3a387d27b993f1ba453afc44744d1bfb"
    sha256 cellar: :any_skip_relocation, ventura:        "e4a773004aa3f41ead36f294b4fe139f31e4939e8774740acb4da696311a9812"
    sha256 cellar: :any_skip_relocation, monterey:       "ec46a733f25e4cf02f7ed0308eb02717264668e2828ad1f0c50cd8205cdd23e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a456539cb5bcb23d14389194ad9b9d303205f6fe45c47a1b9eb8b877b9290fd"
    sha256 cellar: :any_skip_relocation, catalina:       "4554cc599f552716337cb468f0d05dc9afe74081d7ec9f86d4e2621418942b71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44fb0361a0ef22f61a55a160527f63fe1fab72c70f147b1c91953edec1071884"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
