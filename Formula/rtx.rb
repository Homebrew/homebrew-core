class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.23.7.tar.gz"
  sha256 "ff1bb0be9f7808cffa3fc3c65f2bf971457ab54d1ec5a6b4c3859b04a33c6bf5"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce8adeac889a1741dc37a73ab98b4927518991e9c3c95dde5d53dc6e69f65fa9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c100180af293f0663e63e78c20d5092619cbf4c028c555f6cdc9e4d159ad96b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9e25077d51f36072c92ad3d873a3afdd4323ba127f8730af26a6e0f29f7abc9"
    sha256 cellar: :any_skip_relocation, ventura:        "e90d79efe4bcfbba69511c67b9cd4567aad7afe550cedbb92d664b658c6dd1ae"
    sha256 cellar: :any_skip_relocation, monterey:       "f6391c664d2dd919b555d02a2f11382f3243ab3b8ad5b306e22d2d5ee4eac547"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa0b7dcd783ae532a176d58bf0651ed620e118c54fc48450319d767cae775cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1885433b6570f4ce82e5a4e7e662b898ccf7e59353c5afe66b89ec38c1867272"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
