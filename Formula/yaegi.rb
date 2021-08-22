class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.23.tar.gz"
  sha256 "52394e495b36b87d67f40b9104889da3e50eda5dfe5dc5b9eb2795e40c4be135"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c888e4e19d18e059e8d54c3d9197a2f873677828360317d0e3762c4b63b9a203"
    sha256 cellar: :any_skip_relocation, big_sur:       "3bece0545912d85a10600edb69c68fe9daba633c3c9361dc9bc0c7b04854fb5e"
    sha256 cellar: :any_skip_relocation, catalina:      "b25fd4279ffd50071f3a83f1274160ebf6be1c6b7f2c0cadf836a42aaf5ae02f"
    sha256 cellar: :any_skip_relocation, mojave:        "9e863d07455fa41b632d353f6ca7c18e0456a354a65a1dab29ee3e637a78f03f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8318733872a80ebbdcceeabe665d27624aef078a7f5f57e820fe2daa73e01a07"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
