class Triangle < Formula
  desc "Convert images to computer generated art using Delaunay triangulation"
  homepage "https://github.com/esimov/triangle"
  url "https://github.com/esimov/triangle/archive/v1.0.3.tar.gz"
  sha256 "0130bdc9d6c6dd35234134dcb97885d48fa22b5c7532767efbe0394497b96fdd"

  bottle do
    cellar :any_skip_relocation
    sha256 "f337a28da2d8c02b9dee3fcf68736999e66a2e7ed252eb092234bb68f58ab925" => :mojave
    sha256 "748a31500009029b221a4af3755cd3e72e625755adafc1247ae3eae1585250e9" => :high_sierra
    sha256 "254f1a6a4a4e2591f3c3eea6010686a665f32493748058ffcc5deb5d50d6f1a1" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    dir = buildpath/"src/github.com/esimov/triangle"

    dir.install buildpath.children

    cd dir/"cmd/triangle" do
      system "go", "install"
    end
  end

  test do
    system "#{bin}/triangle", "-in", test_fixtures("test.png"), "-out", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
