class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.18.tar.gz"
  sha256 "f1b0f32f02f97b508488c7eea0484ba9f4b6293c604d23aba050cf0b8d826d68"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4737aa16b1b43cf11fd3bfaea436e398c079d1e7d226070acab5badfb952fb67"
    sha256 cellar: :any_skip_relocation, big_sur:       "d07e091f6496ede6c1cb2dff42ae55e82a856218d16c7cdba311c3da9e959f7c"
    sha256 cellar: :any_skip_relocation, catalina:      "8bf87d8fb7b91104f3f35c15e42bc9d02d73ab600ceb1f1cb21e4d5eb4b624e3"
    sha256 cellar: :any_skip_relocation, mojave:        "853ba8ae9497dd1ddeb839d9c3d71042fbea4b7ef9cda551672fcc397fb057cf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
