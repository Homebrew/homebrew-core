class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2023.1.6.tar.gz"
  sha256 "c3a45209348ac0a6ea2018f4b25d483467ad5800ceff483834bce6345256fa62"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "687dbae190708996143671cfd2a63fe554ea28a2e1fd6987a5e10c853c684c07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ae6211403749353bdd5654d5f13b8666b58e6563aa60dff6e024e8429878cfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a6e9b2ddaa0155244d34576ab9209c59b0b41b5010673b1b06b96597d39003a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc0680cbc94e68fccdacf9464061cfe78a613c5abc1c8c4f1791f429be9cd6db"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e68cb01a42bee54283787f4e9f49049ceb4303fc53913fbce98b14243f590c6"
    sha256 cellar: :any_skip_relocation, ventura:        "0ba70ee95d55da4aec3b16548e285fecf8ca8010206f4e0e2ecb51e6cc044028"
    sha256 cellar: :any_skip_relocation, monterey:       "4736fb3ec1d4c271e32c8212306af9acfe3dd5af4001976e9efa69be5e39d4b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa81205f5b2af5cfac842acce27c53e0ce53cde22063088b171b139df7666d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8f954c7cb683abd682b8a7b21170a65e15004b422ac27e157a93e7a5d42b2dd"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "./cmd/staticcheck"
  end

  test do
    (testpath/"test.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        var x uint
        x = 1
        fmt.Println(x)
      }
    EOS
    json_output = JSON.parse(shell_output("#{bin}/staticcheck -f json test.go", 1))
    assert_equal json_output["code"], "S1021"
  end
end
