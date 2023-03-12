class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "0768acc3d4166ed35fbea48f5c24e58491b8c4a8e1721106d9667afab716c403"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "160ff64d0d46a325e3af442e2e3f26d12dca37cf8f7c5deb3f665c485e3ca8ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ed2c5d90185f94c024055c3bee5829dfbd9b6ce98c2b806572728b94f3fbea6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efd3b3b5d775d360ba91f0a394b49d100d1d52d48a9d2b7cac22f318905d4524"
    sha256 cellar: :any_skip_relocation, ventura:        "86edc468d6fc047590a3b160a79f7d05532104da95efa465ad22933d672fa0e7"
    sha256 cellar: :any_skip_relocation, monterey:       "e517e9d470a19fe462f437a215fb3c427d5b64af7df0b99c34593218a59de37b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d447d61151ae2b2b04ff29518330305e4236eafd679a3f411b99bd59e922a04e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba1ac6b825ca0f331bb5c596f445c72ff1e67198057816e8267b3d29cf77d8dd"
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
