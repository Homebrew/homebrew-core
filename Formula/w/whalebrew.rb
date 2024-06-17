class Whalebrew < Formula
  desc "Homebrew, but with Docker images"
  homepage "https://github.com/whalebrew/whalebrew"
  url "https://github.com/whalebrew/whalebrew.git",
      tag:      "0.4.1",
      revision: "8137e562f38ce32d425df4a3676143c2d631d0f1"
  license "Apache-2.0"
  head "https://github.com/whalebrew/whalebrew.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49d1976a3cc330964ceaedbd16bac6f74ebda577fbd2821b084b5208a8bdea25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "add3e44f64fab3b42879f1feda57e1b60e8f21194cc6bb3cfc59005792e39b31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ee597313bdf6047a3bda89bb9dd0fb75c85e4706de548f8b264602c498a27f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49ed81ef33ddec19910c0889703e35e19f6af05e1245c1c4dc8119fc0b69b927"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa70a5b0c08e5bbd20e5f40089c9a1e27eaf71c59e30491284e835e953a0cad3"
    sha256 cellar: :any_skip_relocation, ventura:        "00fa03ff0f1e044041b1e1c54b1e2e36aa41417481d154cf2b85779b21e50d3e"
    sha256 cellar: :any_skip_relocation, monterey:       "5ef0b7ab5462b12ce1d1e6000076bbaaac46e0fa1a008d5eba9da3bfef243a6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "dea3baf9dc0ee45b753174822a6f16ae45e202377814ea8316f589369a80b737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55d5ea63da72e4ee959858e609f27e04eedac26f5cf42409fd1205690cf84df5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/whalebrew/whalebrew/version.Version=#{version}+homebrew
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"whalebrew", "completion")
  end

  test do
    assert_match "Whalebrew #{version}+homebrew", shell_output("#{bin}/whalebrew version")

    output = shell_output("#{bin}/whalebrew install whalebrew/whalesay -y", 255)
    assert_match(/connect to the Docker daemon|operation not permitted/, output)
  end
end
