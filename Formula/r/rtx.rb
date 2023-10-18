class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.10.2.tar.gz"
  sha256 "3b4dcb2dce0399442758360a004189f1d6ade9fe6aae33d72331257dc79f86b4"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "357c8a589534da4d7136792ded5cfe914e290f9c06a6cc0b40958b732a532828"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f7b97d6ce4107daa59418e7ae434d707d9082cd18613ee2db97d9048f547d0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d90e051f7bb2f5eae45403e1b9c8e2fcc1234c181420c3546c70ac4e85d4906"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a59c3cfd43d362f61aeeaaa15c6b0cc65317712f127d01b6ec8d2a404811ae6"
    sha256 cellar: :any_skip_relocation, ventura:        "8f7192fd54e5ec26a9519fa70739bbd8bca97a512e198bb7e4b3e48b62118a78"
    sha256 cellar: :any_skip_relocation, monterey:       "c0459cc6d3157b05865db96253b1002add08dd917c095e9d024506ae1ccfcc0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7100a181668364c247fb44462ea9af956c4faaae7d5a0b7fe654ec8977063e0c"
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
