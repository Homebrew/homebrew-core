class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.17.tar.gz"
  sha256 "976eb88cef567743839d078f2606df25bdd567d4cdf2a015c5df2eaf8524a449"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a1e8e2c0c6fe66f7dd088821eaa273913c2516c785b7cf74f98b3dbeabf95b6f"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a6a6b5d07bde1edc600185323f7c8bbd40ec5bb18859a498fe08c1a4d02fe77"
    sha256 cellar: :any_skip_relocation, catalina:      "b2cdb037f96768cb564939d6b3a918d5d33bc9905d6093cebe5733f79ce538c1"
    sha256 cellar: :any_skip_relocation, mojave:        "72ace26e50042bd7303244dc04a3ccf2d36e446e4276888d791f6c1c0cbb986e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
