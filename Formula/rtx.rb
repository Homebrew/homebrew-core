class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.14.3.tar.gz"
  sha256 "31c5b5689c779705b2dea74795a3ce655a7c0edc1e7c16410eb3cddde05a9a93"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7460596f5d0d87515b1dbbd26284cef52c7d348157759714f881971ea9249dbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41b1c1e7452fd24608e769ad1fa30bda23e932cfda5e1f7d8d9c1ccb0d0b4b39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c10f967832421680db23f9c70cc0e55128af3ef05e31b77cd108c04a698c755"
    sha256 cellar: :any_skip_relocation, ventura:        "0bf2dbdf2144c8a97ab20ddc52817b2b7a4b1e11c0465de24d9b5b665bd8ae2f"
    sha256 cellar: :any_skip_relocation, monterey:       "c085ee755845eb731ef6c4e0c65650436ca06dfebf35d6efc804cfad8ad4212b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a9d7a9ed8d9b06361eac344f26dc0a712e72161f2b8be09abb9685ab6d535b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bea48e3d1cc3ec6a1d7460b9c38f6cf0500f6d67584b3800a3b5da75c4a5471c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
