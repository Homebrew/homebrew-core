class RunKit < Formula
  desc "Universal multi-language runner and smart REPL"
  homepage "https://github.com/Esubaalew/run"
  url "https://github.com/Esubaalew/run/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "9faf29540471da65f9481b2fa95aa7513572110d428f7199a27fe04ca1be2896"
  license "Apache-2.0"
  head "https://github.com/Esubaalew/run.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9104ed02ddf561bf06bf75c5db9b7cfb97b4a383af0190e17c9d11fa47ad0910"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47cc94c954b1e6720545f6d8c9e9031071c3b1055d6aff16f84659f4d2d07b15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0436fe0f7ac43a1d21ac673be88458103235854c01fa6ec270fd64fe0ddc8746"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae79c6e82780675707f7c206faa2ef0d7dd4b17ba9a3a81197ed3351e599ca71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5493fca2cb6ceebcc6855f2bffaa5daa03c3f502083c5f7ae6a871e95ed7458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6c0ce83f8a22619f4ea16cf882080b47b494234655c04a8b5ba07d124d844a6"
  end

  depends_on "rust" => :build

  conflicts_with "run", because: "both install a `run` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "brew", shell_output("#{bin}/run bash \"echo brew\"")
  end
end
