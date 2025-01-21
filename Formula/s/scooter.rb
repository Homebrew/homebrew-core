class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://github.com/thomasschafer/scooter/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "3585c1d2d335f6bef23c9aa2f55fec82f956c9d20ebfcdb5c9cd1aca76978525"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c442d6b86deeafceb15410b13b8f788ec617133cdc09045662281ec6ba41bc8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a659655b053c1cd0cf33b176af4c0a6cfbcce7f242253ce520a6cf1ffd146e2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ab8181ea6a1c14a242759c2c7b5655d8ec5fa27791e5dc51680ca7c7d347e9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d81444f7bc95a9626cd2c5bf66149593efa7e6077980feabd35de1e363d805fd"
    sha256 cellar: :any_skip_relocation, ventura:       "f85bd8158a57f131dedc86c5abcab6f578a9763362b7bae3d315426801b8210c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b49e5b151751cd465fcc357e4ccdd4ab1187f55a052bbf39b15aba824b87366"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end
