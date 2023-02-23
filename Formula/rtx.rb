class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "980222fa2732ddae26ccd7bc3ec5615b92607eb655b5b6fc64b2613993ea327f"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddc5c782303b866979221c18e443116e2e2b2a9e1bb1aa8dff468812ca0c8918"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "229d33e26f6f6494e9528417e6d94acb89d38c5cb0605dfdad777f0efa414d67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3c9ce64275b4ff9d55d5daee0ecf09c755a89a2c09d3310ae29e5e1b7e40f12"
    sha256 cellar: :any_skip_relocation, ventura:        "0d575353eda42b81a330e173906a314921a7785d20cefd522c0d586476ab6ab3"
    sha256 cellar: :any_skip_relocation, monterey:       "4d0f46de8977eeb6f48219e11a3c568a412f041c881f91840d3f4cb102eb1a30"
    sha256 cellar: :any_skip_relocation, big_sur:        "827b8e486499d01ee8c26c9f85d7ae08e09cc04169d2c6b3c36fae49e93b19df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6b8ea204e511bf897fbcf66e30b41827eb354043d8f9ae33a63ad965f1240d3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
