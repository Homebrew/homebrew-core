class Wgo < Formula
  desc "Watch arbitrary files and respond with arbitrary commands"
  homepage "https://github.com/bokwoon95/wgo"
  url "https://github.com/bokwoon95/wgo/archive/refs/tags/v0.5.13.tar.gz"
  sha256 "df4066625be131c5c03bce9ffbf9a12760fab192ca7863671a01fcf7c1d9ddbd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e97a393d0057145e6a99f567014839c09557351fa7600a6999d489916d569c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e97a393d0057145e6a99f567014839c09557351fa7600a6999d489916d569c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e97a393d0057145e6a99f567014839c09557351fa7600a6999d489916d569c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d69779b69ae4617935085aa99b368598e323241ad16f6bdaab97a02a9731eb7"
    sha256 cellar: :any_skip_relocation, ventura:       "5d69779b69ae4617935085aa99b368598e323241ad16f6bdaab97a02a9731eb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bba8d9539389bbc6705136129c8a35918492bbddd0e9a616910aad8259c2172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8137ba64ce3a4b7f698b5554ca81a1afb5a8235ad2d0027ec69bf6a7cc7212df"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/wgo -exit echo testing")
    assert_match "testing", output
  end
end
