class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.9.6.tar.gz"
  sha256 "783c22f29ee371b43ec27f9ca72f9fcd3cbe66ff0472b65a635814ac044535a2"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5dcd7fdafd270a3f903b1774d96cb633d4c87be831c7bd9387af0d0cba79f1d8" => :catalina
    sha256 "f9f1448c08fe4c445badd809297e662d35ddd03fdf639e43d267b15250bc265f" => :mojave
    sha256 "c7f2579c42d3b21711e162d7677cac3b625aa84b8260181b90f7a8b1ea5501b6" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
