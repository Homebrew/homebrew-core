class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.25.0.tar.gz"
  sha256 "6c3a9b45fdda66d548a12a37c9978477bd927fd53e6f7f08d11159a480c8ea77"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c9c2ffa1483e9ae2143f23f70ae3afac94c6aa481f65078b5fcc1c07e70d18b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b83274e1bb3a7e425ed79c7f06e37a8fe3653e4c8a802f5086a8d595cbed6f5"
    sha256 cellar: :any_skip_relocation, monterey:       "312bf5bf656ced6925045f706913344389f44cdf7a3e39ed62dfc42ad9a79249"
    sha256 cellar: :any_skip_relocation, big_sur:        "83fb4cc288639950df602bd56a2536fc337fed4c580d97ecfb6a5b9766b1e5a5"
    sha256 cellar: :any_skip_relocation, catalina:       "4f6076c24f2915c35a9d40f31c655b62ae9c5bdd85301924c7f7e0f21b6a64b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10c54bd56904efb5ef372be416a2bc855a859e6324df78375bb8754d3e009532"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"
  end

  test do
    expected = <<~END
      +-------------------+-------+
      | CONFIGURATION KEY | VALUE |
      +-------------------+-------+
      | region            |       |
      +-------------------+-------+
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
