class Xe < Formula
  desc "Simple xargs and apply replacement"
  homepage "https://github.com/leahneukirchen/xe"
  url "https://github.com/leahneukirchen/xe/archive/refs/tags/v1.0.tar.gz"
  sha256 "1e2484c6295f4eb1c1b789d8edab4b728cf9ea7e4c40ef52a56073f9a273ce30"
  license :public_domain
  head "https://github.com/leahneukirchen/xe.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6f8bcbd2aa8d72e333c3ed215a2da7316c5e0799fd93b976ada5abba1b59760"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ac1291f6de1676653a4a1e492d9ce64932d1d320b84c95dbdef6b74d9283a54"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f982ff586896b25e221c24cacf9cd996d63c98efea30154be9c3b06560a4a8b"
    sha256 cellar: :any_skip_relocation, ventura:        "0815d3d11140b42d7bade06e528d2522f160a5c57da733cc3866bf64517fe04d"
    sha256 cellar: :any_skip_relocation, monterey:       "b4980448b2979d5d3c21055c7a0370eb861b22077002dcca4e6a5766a17cfb2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "512eb8d361560ba10ab724184fdf09469f944f3453710da493807b8c4d7faa46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e3306a94b8bb04cd922cbd2109ea31c7ec51c4056b45ba7705e53c5f2ab7609"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"input").write "a\nb\nc\nd\n"
    assert_equal "b a\nd c\n", shell_output("#{bin}/xe -f #{testpath}/input -N2 -s 'echo $2 $1'")
  end
end
